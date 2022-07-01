module Pages.MainPage exposing (..)

import Browser
import Element exposing (..)
import Element.Font as Font
import Http
import Messages exposing (MainPageMessage(..), Message(..))
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarLink)
import Pages.CreatePost as CP
import Pages.ViewPost as VP
import Pages.FromJson.MainPage exposing (MainPageInitParams, SubpageInitParams(..), decodeSubpageData)
import Pages.PagesModels.MainPageModel as MainPageModel exposing (ActiveSubpage, Error(..), MainPageModel, SubpageModel(..))
import Pages.PagesModels.LoadingPageModel as L
import Pages.Loading as L
import Pages.Link as Lnk
import Pages.SubpageUrl exposing (SubpageUrl)
import Url exposing (Url)




--      INIT


initModel: MainPageInitParams -> Url -> Result Error (MainPageModel, Cmd Message)
initModel mainPageInitParams url =
    let
        absoluteUrl: String -> String
        absoluteUrl relative =
            mainPageInitParams.baseUrl ++ "/" ++ relative

        pagesUrls =
                    {
                        createPostPageUrl = absoluteUrl mainPageInitParams.createPostPageUrl
                       ,viewAllPostsPageUrl = absoluteUrl mainPageInitParams.viewAllPostsPageUrl
                    }
    in
    Ok <| ( MainPageModel [
            -- todo: once server starts sending localized strings, remove hardcoded link text (fix deserializer)
            Lnk.Link pagesUrls.createPostPageUrl "Create post" Lnk.CreatePost,
            Lnk.Link pagesUrls.viewAllPostsPageUrl "View all posts" Lnk.ViewAllPosts
        ]
        "Nothing clicked"
        []
        (ActiveSubpage url HomePageModel)
        pagesUrls

        , Cmd.none
       )





--      UPDATE

update: MainPageModel -> MainPageMessage -> (MainPageModel, Cmd Message)
update mainPageModel message =
        case message of
            LinkClicked url ->
                case Debug.log "Clicked url: " url of
                    Browser.Internal href ->
                        case intoPageUrl href mainPageModel of
                            Nothing -> (mainPageModel, Cmd.none)    -- fixme: don't ignore.
                            Just pageUrl ->
                                case viewUrl pageUrl mainPageModel of
                                    Ok (activeSubpage, cmd) ->
                                        ({mainPageModel | activeSubpage = activeSubpage}, cmd)

                                    -- fixme: don't ignore
                                    Err e -> (Debug.log ("Err: " ++ MainPageModel.errToString e) mainPageModel, Cmd.none)

                    Browser.External href ->
                        ({mainPageModel | text = "Clicked url: " ++ href}, Cmd.none)

            GotPageInfo url response ->
                processGotPageInfoMsg url response mainPageModel

            _ -> (mainPageModel, Cmd.none)



processGotPageInfoMsg: SubpageUrl -> Result Http.Error Pages.FromJson.MainPage.SubpageInitParams -> MainPageModel -> (MainPageModel, Cmd Message)
processGotPageInfoMsg url response mpModel =
    -- todo: create type Page and process all pages identically
    -- find out which page the response corresponds to
    case Debug.log "matching page type" url.pageType of
        Lnk.CreatePost ->       -- todo: make a distinct function for this
            case Debug.log "checking url" CP.isSamePage mpModel.activeSubpage.url url.url of
                True -> (Debug.log "Same url" mpModel, Cmd.none) -- page is already shown

                False -> -- init new Create post page and put its model into MPModel
                    case Debug.log "resp" response of
                        Err _ -> (Debug.log ("Error loading page: ") mpModel, Cmd.none)  -- fixme: don't ignore
                        Ok initParams ->
                            case Debug.log "Init pampams" initParams of
                                -- fixme: page type checks twice
                                CreatePostPageInitParams pampams ->
                                    let
                                        cpModel = CP.initModel pampams
                                        newActivePage = case cpModel of
                                                            Ok val -> Ok <| ActiveSubpage url.url (CreatePostModel val)
                                                            Err e -> Err e   -- fixme: don't ignore
                                    in
                                    case newActivePage of
                                        Ok val ->
                                            ({mpModel | activeSubpage = Debug.log "Active subpage is cp now" val}, Cmd.none)  -- todo: put newly loaded page into mpModel.alreadyLoadedPages
                                        Err e -> (Debug.log "E1" mpModel, Cmd.none)        -- fixme: don't ignore

                                _ -> (Debug.log ("Error loading page: ") mpModel, Cmd.none)  -- fixme: don't ignore

        Lnk.ViewAllPosts ->
            case VP.isSamePage url.url mpModel.activeSubpage.url of
                True -> (mpModel, Cmd.none) -- page is already shown
                False ->
                     case Debug.log "checking resp" response of
                        Err _ -> (Debug.log ("Error loading page: ") mpModel, Cmd.none)  -- fixme: don't ignore
                        Ok initParams ->
                            case initParams of
                                ViewPostPageInitParams pampams ->
                                    let
                                        vpModel = VP.initModel pampams
                                        newActivePage = case vpModel of
                                            Ok val -> Ok <| ActiveSubpage url.url (ViewPostModel val)
                                            Err e -> Err e   -- fixme: don't ignore
                                    in
                                    case newActivePage of
                                        Ok val ->
                                            ({mpModel | activeSubpage = Debug.log "Active subpage is vp now" val}, Cmd.none)  -- todo: put newly loaded page into mpModel.alreadyLoadedPages
                                        Err e -> (Debug.log "E2" mpModel, Cmd.none)                     -- fixme: don't ignore

                                _ -> (Debug.log ("Error loading page 1: ") mpModel, Cmd.none)  -- fixme: don't ignore


requestPageParams: SubpageUrl -> Cmd Message
requestPageParams url =
    Http.get
        {
            url = Url.toString url.url
          , expect = Http.expectJson (\result -> Messages.MPMessage <| Messages.GotPageInfo url result) decodeSubpageData
        }


intoPageUrl: Url -> MainPageModel -> Maybe SubpageUrl
intoPageUrl url model =
    let
        strUrl = Debug.log "Trying to match url: " <| Url.toString url
    in

    if (String.startsWith model.subpagesUrls.createPostPageUrl strUrl) then Just <| SubpageUrl Lnk.CreatePost url else
    if (String.startsWith model.subpagesUrls.viewAllPostsPageUrl strUrl) then Just <| SubpageUrl Lnk.ViewAllPosts url else
        Nothing


--      VIEW


view: MainPageModel -> Element Message
view model =
    let

        collectSidebarItems =
           List.map (\item -> SidebarLink item.url item.text []) model.sidebarLinks


        sidebarModel =
           SidebarModel collectSidebarItems

    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                       ,viewSubpage model.activeSubpage.subpageModel
                    ]




viewUrl: SubpageUrl -> MainPageModel -> Result Error (ActiveSubpage, Cmd Message)
viewUrl url model =
    let
        loadingPageCrutch = case Url.fromString ((Url.toString url.url) ++ "loading-mock") of
            Just val -> val
            Nothing -> url.url
    in
    case List.filter (\li -> li.url == Url.toString (Debug.log "Called viewUrl with " url.url)) model.alreadyLoadedPages of
        [] -> Ok (ActiveSubpage loadingPageCrutch (LoadingPageModel L.defaultPageModel), requestPageParams <| Debug.log "Loading url: " url)
        [item] -> Ok ((ActiveSubpage (Debug.log "Already existing loaded page: " url.url) item.pgModel), Cmd.none)

        _ -> Err <| SeveralPagesWithSameUrl <| Url.toString <| Debug.log "Err: " url.url



viewLoadingPage: L.LoadingPageModel -> Element Message
viewLoadingPage m =
    L.view m


viewHomepage: Element Message
viewHomepage =
    (text "Me home!")



viewSubpage: SubpageModel -> Element Message
viewSubpage subpageModel =
    case subpageModel of
        CreatePostModel m -> CP.view m
        LoadingPageModel m -> viewLoadingPage m
        HomePageModel -> viewHomepage
        ViewPostModel m -> VP.view m
        _ -> (text "Unknown page!")




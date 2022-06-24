module Pages.MainPage exposing (..)

import Browser
import Element exposing (..)
import Element.Font as Font
import Http
import Messages exposing (MainPageMessage(..), Message(..))
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarLink)
import Pages.CreatePost as CP
import Pages.FromJson.MainPage exposing (MainPageInitParams, decodeSubpageData)
import Pages.PagesModels.MainPageModel exposing (Error(..), MainPageModel, SubpageModel(..), ActiveSubpage)
import Pages.PagesModels.LoadingPageModel as L
import Pages.Loading as L
import Pages.Link as Lnk
import Pages.SubpageUrl exposing (SubpageUrl)
import Url exposing (Url)




--      INIT


initModel: MainPageInitParams -> Url -> Result Error (MainPageModel, Cmd Message)
initModel mainPageInitParams url =
    Ok <| ( MainPageModel [
            -- todo: once server starts sending localized strings, remove hardcoded link text (fix deserializer)
            Lnk.Link mainPageInitParams.createPostPageUrl "Create post" Lnk.CreatePost,
            Lnk.Link mainPageInitParams.viewAllPostsPageUrl "View all posts" Lnk.ViewAllPosts
        ]
        "Nothing clicked"
        []
        (ActiveSubpage url HomePageModel)
        {
            createPostPageUrl = mainPageInitParams.createPostPageUrl
           ,viewAllPostsPageUrl = mainPageInitParams.viewAllPostsPageUrl
        }

          , Cmd.none )





--      UPDATE

update: MainPageModel -> MainPageMessage -> (MainPageModel, Cmd Message)
update mainPageModel message =
        case message of
            LinkClicked url ->
                case url of
                    Browser.Internal href ->
                        case intoPageUrl href mainPageModel of
                            Nothing -> (mainPageModel, Cmd.none)    -- todo: don't ignore.
                            Just pageUrl ->
                                case viewUrl pageUrl mainPageModel of
                                    Ok (activeSubpage, cmd) ->
                                        ({mainPageModel | activeSubpage = activeSubpage}, cmd)

                                    Err _ -> (mainPageModel, Cmd.none)

                    Browser.External href ->
                        ({mainPageModel | text = "Clicked url: " ++ href}, Cmd.none)

            GotPageInfo url response ->
                processGotPageInfoMsg url response mainPageModel

            _ -> (mainPageModel, Cmd.none)


processGotPageInfoMsg: SubpageUrl -> Result Http.Error Pages.FromJson.MainPage.SubpageInitParams -> MainPageModel -> (MainPageModel, Cmd Message)
processGotPageInfoMsg url response mpModel =
    case response of
        Err er -> (mpModel, Cmd.none)
        Ok val -> (mpModel, Cmd.none)




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
        strUrl = url.path
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
    case List.filter (\li -> li.url == Url.toString url.url) model.alreadyLoadedPages of
        [] -> Ok (ActiveSubpage url.url (LoadingPageModel L.defaultPageModel), requestPageParams url)
        [item] -> Ok ((ActiveSubpage url.url item.pgModel), Cmd.none)

        _ -> Err <| SeveralPagesWithSameUrl <| Url.toString url.url



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
        _ -> (text "Unknown page!")




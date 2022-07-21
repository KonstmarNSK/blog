module Pages.MainPage exposing (..)

import Browser
import Element exposing (..)
import Element.Font as Font
import Messages.Messages exposing (MainPageMessage(..), Message(..))
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarLink)
import Pages.CreatePost as CP
import Pages.HomePage as HP
import Pages.Loading
import Pages.PageType as PT exposing (PageType)
import Pages.FromJson.MainPage exposing (MainPageInitParams, SubpageInitParams(..))
import Pages.PagesModels.MainPageModel exposing (..)--(ActiveSubpage, AlreadyLoadedPage, AlreadyLoadedPages(..), Error(..), MainPageModel, PageUrl(..), SubpageModel(..), pageUrlIntoUrl)
import Pages.PagesModels.LoadingPageModel as L
import Pages.Link as Lnk
import Url exposing (Url)
import Pages.ShowAllPosts as SA
import Pages.NotFoundPage as NF




--      INIT


initModel: MainPageInitParams -> Url -> Result Error (MainPageModel, Cmd Message)
initModel mainPageInitParams url =
    let
        pageUrlPrefix = Lnk.PageRootPrefix mainPageInitParams.pageUrlPrefix
        apiUrlPrefix = Lnk.ApiRootPrefix mainPageInitParams.apiUrlPrefix

        pagesLinks =
            List.filterMap
                (\maybe -> maybe)
                [
                    CP.getPageLink pageUrlPrefix <| (Lnk.LinkText "Create page"),
                    SA.getPageLink pageUrlPrefix <| (Lnk.LinkText "Show all posts")
                ]

        (activePage, cmd) = loadPage url (Lnk.ApiRootPrefix mainPageInitParams.apiUrlPrefix) EmptyAlreadyLoadedPages

    in
        Ok <| ( MainPageModel
                    pagesLinks
                    EmptyAlreadyLoadedPages
                    activePage
                    apiUrlPrefix
                    pageUrlPrefix
            , cmd
           )



-- figures out what page type given url corresponds to,
-- then tries to get that page data from already loaded pages data and if there is nothing loaded, tries to load
loadPage: Url -> Lnk.ApiRootPrefix-> AlreadyLoadedPages -> (ActiveSubpage, Cmd Message)
loadPage url apiPrefix alreadyLoadedPages =
    let
        -- first, check what type of pages given url corresponds to
        pageType =
            case determinePageType url of
                Just pt -> pt
                Nothing -> PT.NotFound404

        pageUrl = PageUrl pageType url

        -- we try to find specified url in inactive already loaded pages
        findAlreadyLoaded: AlreadyLoadedPages -> List AlreadyLoadedPage
        findAlreadyLoaded alreadyLoaded =
            case alreadyLoaded of
               AlreadyLoadedPages alreadyLoadedPagesData ->
                    List.filter (\page ->
                            case page of
                                AlreadyLoadedPage pgData ->
                                    -- if we found loaded page with same type, check if url is same as requested
                                    case pgData.pageType == pageType of
                                        False -> False
                                        True -> isSameUrl pageUrl pgData.url
                            ) alreadyLoadedPagesData.alreadyLoadedPages

               EmptyAlreadyLoadedPages -> []


        intoActivePage: (AlreadyLoadedPage, Cmd Message) -> (ActiveSubpage, Cmd Message)
        intoActivePage (alreadyLoadedPage, cmd) = (ActiveSubpage alreadyLoadedPage, cmd)

    in
        case alreadyLoadedPages of
           AlreadyLoadedPages alreadyLoadedPagesData ->
                case isActivePage pageUrl alreadyLoadedPagesData.activeSubpage of
                    True -> (alreadyLoadedPagesData.activeSubpage, Cmd.none)  -- page with given url is already active, do nothing
                    False ->
                        case findAlreadyLoaded alreadyLoadedPages of
                            [item] -> (ActiveSubpage item, Cmd.none)  -- page with given url is already loaded, just make it active
                            _ -> intoActivePage <| loadPage2 pageUrl apiPrefix   -- load page data

           EmptyAlreadyLoadedPages -> intoActivePage <| loadPage2 pageUrl apiPrefix





-- actually tries to load page data. Todo: rename
loadPage2: PageUrl PageType -> Lnk.ApiRootPrefix-> (AlreadyLoadedPage, Cmd Message)
loadPage2 url apiPrefix =
    let
        -- todo: rename
        exactPageOrLoading: Maybe SubpageModel -> SubpageModel
        exactPageOrLoading maybeLoaded =
            case maybeLoaded of
                Nothing -> LoadingPageModel loadingPage
                Just loaded -> loaded



        loadingPage = L.LoadingPageModel

    in
    case url of                  -- fixme: version number must be passed as an argument from model, remove hardcoded 0
        PageUrl PT.CreatePost _ -> case CP.loadPage apiPrefix 0 of
                                    (loadedPage, command) ->
                                        (
                                            AlreadyLoadedPage {
                                                pageType = PT.CreatePost,
                                                url = url,
                                                pageModel = exactPageOrLoading <| Maybe.map CreatePostModel loadedPage
                                            }
                                            , command
                                        )

        PageUrl PT.Home _ -> (
                               AlreadyLoadedPage {
                                   pageType = PT.Home,
                                   url = url,
                                   pageModel = HomePageModel
                               }
                              , Cmd.none
                           )
        _ -> (
                AlreadyLoadedPage {
                    pageType = PT.Home,
                    url = url,
                    pageModel = HomePageModel
                }
               , Cmd.none
            )
        --PageUrl PT.ViewAllPosts ->
        --PageUrl PT.NotFound404 ->
        --PageUrl PT.Loading ->


setPageActive: Url -> MainPageModel -> (MainPageModel, Cmd Message)
setPageActive url mainPageModel =
    let
      --loadPage: Url -> Lnk.ApiRootPrefix-> AlreadyLoadedPages -> (ActiveSubpage, Cmd Message)
      (activePage, cmd) = loadPage url mainPageModel.apiUrlPrefix mainPageModel.alreadyLoadedPages
    in
      ({ mainPageModel | activeSubpage = activePage}, cmd)



-- whether given url matches one that active subpage has
isActivePage: PageUrl PageType -> ActiveSubpage -> Bool
isActivePage url activeSubpage =
    case activeSubpage of
        ActiveSubpage alreadyLoaded ->
            case alreadyLoaded of
                AlreadyLoadedPage alreadyLoadedData ->
                    isSameUrl alreadyLoadedData.url url




isSameUrl: PageUrl PageType -> PageUrl PageType -> Bool
isSameUrl url url2 =
    case url of
        PageUrl PT.CreatePost u -> CP.isSamePage u (pageUrlIntoUrl url2)
        PageUrl PT.ViewAllPosts u -> SA.isSamePage u (pageUrlIntoUrl url2)
        PageUrl PT.Home u ->  HP.isSamePage u (pageUrlIntoUrl url2)
        PageUrl PT.NotFound404 u -> NF.isSamePage u (pageUrlIntoUrl url2)
        PageUrl PT.Loading _ -> False




determinePageType: Url -> Maybe PageType
determinePageType url =
    let
        matchers: List (Url -> Maybe PageType)
        matchers =
            [
                CP.determinePageType,
                SA.determinePageType,
                HP.determinePageType
            ]

    in
        case List.filterMap (\matcher -> matcher url) matchers of
            -- todo: properly handle case when we have multiple items in list, i.e. given url matches several page types
            [item] -> Just item
            _ -> Nothing





--      UPDATE

update: MainPageModel -> MainPageMessage -> (MainPageModel, Cmd Message)
update mainPageModel message =
        case message of
            LinkClicked url ->
                case Debug.log "Clicked url: " url of
                    Browser.Internal href ->
                        setPageActive href mainPageModel

                    Browser.External href ->
                        (mainPageModel, Cmd.none)

            _ -> (mainPageModel, Cmd.none)



--      VIEW


view: MainPageModel -> Element Message
view model =
    let
        collectSidebarItems =
           List.map (\item -> SidebarLink (Url.toString item.url) item.text []) model.sidebarLinks

        sidebarModel =
           SidebarModel collectSidebarItems

        subpageToDraw =
           case model.activeSubpage of
               ActiveSubpage alreadyLoaded ->
                   case alreadyLoaded of
                       AlreadyLoadedPage data -> data.pageModel

    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                       ,viewSubpage subpageToDraw
                    ]



viewSubpage: SubpageModel -> Element Message
viewSubpage subpageModel =
    case subpageModel of
        CreatePostModel m -> CP.view m
        LoadingPageModel m -> Pages.Loading.view m
        HomePageModel -> HP.view
        _ -> (text "Unknown page!")




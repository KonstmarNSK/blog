module Pages.MainPage exposing (..)

import Browser
import Element exposing (..)
import Element.Font as Font
import Messages exposing (MainPageMessage(..), Message(..))
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarLink)
import Pages.CreatePost as CP exposing (PostCreationPageModel)
import Pages.FromJson.MainPage exposing (MainPageInitParams)
import Pages.Link exposing (Link)
import Url exposing (Url)



--      MODEL

type alias PageName = String
type alias PageUrl = String


type alias MainPageModel = {
        sidebarLinks: List Link
       ,text: String
       ,alreadyLoadedPages: List AlreadyLoadedPage
       ,activeSubpage: (Url, SubpageModel)
    }

type alias AlreadyLoadedPage = {
        pgModel: SubpageModel,
        url: String
    }

type SubpageModel =
      CreatePostModel PostCreationPageModel
    | ViewPostModel
    | ShowAllPostsModel
    | LoadingPageModel
    | HomePageModel



--      INIT


initModel: MainPageInitParams -> Url -> Result Error (MainPageModel, Cmd Message)
initModel mainPageInitParams url =
    Ok <| ( MainPageModel mainPageInitParams.sidebarLinks "Nothing clicked" [] (url, HomePageModel), Cmd.none)





--      UPDATE

update: MainPageModel -> MainPageMessage -> (MainPageModel, Cmd Message)
update mainPageModel message =
        case message of
            LinkClicked url ->
                case url of
                    Browser.Internal href ->
                        ({mainPageModel | text = "Clicked url: " ++ (Url.toString href)}, Cmd.none)
                    Browser.External href ->
                        ({mainPageModel | text = "Clicked url: " ++ href}, Cmd.none)
            _ -> (mainPageModel, Cmd.none)




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
                       , case model.activeSubpage of (_, m) -> viewSubpage m
                    ]




viewUrl: Url -> MainPageModel -> Result Error ((Url, SubpageModel), Cmd Message)
viewUrl url model =
    case List.filter (\li -> li.url == Url.toString url) model.alreadyLoadedPages of
        [] -> Ok ((url, LoadingPageModel), Cmd.none)
        [item] -> Ok ((url, item.pgModel), Cmd.none)

        _ -> Err <| SeveralPagesWithSameUrl <| Url.toString url



viewLoadingPage: Element Message
viewLoadingPage =
    (text "Loading...")


viewHomepage: Element Message
viewHomepage =
    (text "Me home!")



viewSubpage: SubpageModel -> Element Message
viewSubpage subpageModel =
    case subpageModel of
        CreatePostModel m -> CP.view m
        LoadingPageModel -> viewLoadingPage
        HomePageModel -> viewHomepage
        _ -> (text "Unknown page!")



--      ERRORS

type Error =
     ModelInitErr String
   | UnknownPageType String String   -- first is page type, second - error message
   | SeveralPagesWithSameUrl String


errToString: Error -> String
errToString error =
    case error of
        ModelInitErr err -> err
        UnknownPageType pgName description -> "No such page " ++ pgName ++ " (" ++ description ++ ")"
        SeveralPagesWithSameUrl url -> "Found several pages with same url: " ++ url

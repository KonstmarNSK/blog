module Pages.MainPage exposing (..)

import Element exposing (..)
import Element.Font as Font
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Messages exposing (MainPageMessage(..), Message)
import PageParts.Common
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarEntry)
import Pages.CreatePost as CP exposing (PostCreationPageModel)
import Pages.FromJson.CreatePostPage as CP
import Pages.FromJson.MainPage as MP exposing (MainPageInitParams, SubpageInitParams(..))



--      MODEL

type alias PageName = String
type alias PageUrl = String


type alias MainPageModel = {
        activeSubpage: ActiveSubpage
       ,inactiveSubpages: List InactiveSubpage
       ,clicked: String
    }


type InactiveSubpage =
     UrlOnly PageName PageUrl   -- contains its name and url which can be used to retrieve its data
   | AlreadyLoaded PageName SubpageModel


type alias ActiveSubpage = {
        pageModel: SubpageModel
       ,pageName: String
    }



type SubpageModel =
      CreatePostModel PostCreationPageModel
    | ViewPostModel
    | ShowAllPostsModel





--      INIT


initModel: MainPageInitParams -> Result Error (MainPageModel, Cmd Message)
initModel mainPageInitParams =
    let
        activeSubpageName = mainPageInitParams.activeSubpageData.subpageName

        activeSubpage: Result Error ActiveSubpage
        activeSubpage =
            case mainPageInitParams.activeSubpageData.subpageInitParams of
                CreatePostPageInitParams cpInitParams ->
                    initCPActivePage cpInitParams



        initCPActivePage: CP.PageInitParams -> Result Error ActiveSubpage
        initCPActivePage cpInitParams =
            case CP.initModel activeSubpageName cpInitParams of
                Ok cpModel -> Ok
                    <| ActiveSubpage
                        (CreatePostModel cpModel)
                        activeSubpageName

                Err cpErr -> Err
                    <| ModelInitErr
                    <| "Failed to create model of page 'Create post': " ++ CP.errToString cpErr
    in

        case activeSubpage of
            Ok subpage ->
                Ok <| (
                    MainPageModel
                        subpage
                        (List.map (\sp -> UrlOnly sp.subpageName sp.subpageUrl) mainPageInitParams.inactiveSubpages)
                        "None"

                    , Cmd.none
                )

            Err e -> Err e





--      UPDATE

update: MainPageModel -> Message -> (MainPageModel, Cmd Message)
update mainPageModel message =
    let
        excludeInactivePage: List InactiveSubpage -> InactiveSubpage -> List InactiveSubpage
        excludeInactivePage inactiveSubpages subpageToExclude =
            (List.filter (\el -> el /= subpageToExclude) inactiveSubpages)


        makePageInactive: MainPageModel -> (InactiveSubpage, MainPageModel)
        makePageInactive model =
            let inactivated = AlreadyLoaded model.activeSubpage.pageName model.activeSubpage.pageModel in
            (inactivated, {model | inactiveSubpages = [inactivated] ++ model.inactiveSubpages})


        makePageActive: InactiveSubpage -> MainPageModel -> (MainPageModel, Cmd Message)
        makePageActive inactive model =
            case inactive of
                AlreadyLoaded pgName pgModel ->
                    ({model
                        | inactiveSubpages = (excludeInactivePage model.inactiveSubpages inactive)
                        , activeSubpage = ActiveSubpage pgModel pgName
                    }, Cmd.none)


                UrlOnly pgName pgUrl -> (model, Http.get
                                                      { url = pgUrl
                                                      , expect = Http.expectJson
                                                            (\decodeResult ->
                                                                Messages.MPMessage
                                                                    <| LoadedPageInfo ("1-" ++ pgName) decodeResult
                                                            )
                                                            MP.decodeSubpageInitParams
                                                      })

    in 
    case message of
        Messages.MPMessage
            (Messages.SidebarItemClicked
              (Messages.PageLinkClicked
                (Messages.NotLoadedPage pageId pageUrl)))  ->

                ({mainPageModel | clicked = "clicked on " ++ pageId ++ ", url is " ++ pageUrl}, Cmd.none)

        _ -> (mainPageModel, Cmd.none)




--      VIEW


view: MainPageModel -> Element Message
view model =
    let
        inactiveSubpageToSidebarEntry: InactiveSubpage -> (String -> SidebarEntry Message)
        inactiveSubpageToSidebarEntry subpage =
            \strId ->
                case subpage of
                    UrlOnly name url -> SidebarEntry strId name [
                            PageParts.Common.onClick
                                <| Messages.MPMessage
                                <| Messages.SidebarItemClicked
                                <| Messages.PageLinkClicked
                                <| Messages.NotLoadedPage strId url

                        ] -- todo: url must be passed to produced event
                    AlreadyLoaded name m -> SidebarEntry strId name []


        activeSubpageToSidebarEntry: ActiveSubpage -> (String -> SidebarEntry Message)
        activeSubpageToSidebarEntry subpage =
            \strId ->
                SidebarEntry strId subpage.pageName []


        collectSidebarItems =
           List.indexedMap
                (\idx sbi -> sbi <| "sidebar-entry-" ++ String.fromInt idx)
                <| (
                        [ activeSubpageToSidebarEntry model.activeSubpage ]
                        ++
                        List.map inactiveSubpageToSidebarEntry model.inactiveSubpages
                   )


        sidebarModel =
           SidebarModel collectSidebarItems


        showSubpage: SubpageModel -> Element Message
        showSubpage m =
            case m of
                CreatePostModel cpModel -> CP.view cpModel
                _ -> text "other"

    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                       ,showSubpage model.activeSubpage.pageModel
                    ]


--      ERRORS

type Error =
     ModelInitErr String
   | UnknownPageType String String   -- first is page type, second - error message


errToString: Error -> String
errToString error =
    case error of
        ModelInitErr err -> err
        UnknownPageType pgName description -> "No such page " ++ pgName ++ " (" ++ description ++ ")"

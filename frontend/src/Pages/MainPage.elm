module Pages.MainPage exposing (..)

import Element exposing (..)
import Element.Font as Font
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Messages exposing (Message)
import PageParts.Common
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarEntry)
import Pages.CreatePost as CP exposing (PostCreationPageModel)



--      MODEL

type alias PageName = String
type alias PageUrl = String


type alias MainPageModel = {
        activeSubpage: ActiveSubpageData
       ,inactiveSubpages: List InactiveSubpage
       ,clicked: String
    }


type InactiveSubpage =
     UrlOnly PageName PageUrl   -- contains its name and url which can be used to retrieve its data
   | AlreadyLoaded PageName SubpageModel


type alias ActiveSubpageData = {
        page: SubpageModel
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

        activeSubpage: Result Error ActiveSubpageData
        activeSubpage =
            case mainPageInitParams.activeSubpageData.subpageInitParams of
                CreatePostPageInitParams cpInitParams ->
                    initCPActivePage cpInitParams



        initCPActivePage: CP.PageInitParams -> Result Error ActiveSubpageData
        initCPActivePage cpInitParams =
            case CP.initModel activeSubpageName cpInitParams of
                                    Ok cpModel -> Ok
                                        <| ActiveSubpageData
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
    case message of
        Messages.SidebarMsg (Messages.SidebarItemClicked (Messages.NotLoadedPage pageId pageUrl))  ->
            ({mainPageModel | clicked = "clicked on " ++ pageId ++ ", url is " ++ pageUrl}, Cmd.none)






--      VIEW


view: MainPageModel -> Element Message
view model =
    let
        -- takes id of HTML element corresponding to this sidebar entry + entry itself
        inactiveSubpageToSidebarEntry: InactiveSubpage -> (String -> SidebarEntry Message)
        inactiveSubpageToSidebarEntry subpage =
            \strId ->
                case subpage of
                    UrlOnly name url -> SidebarEntry strId name [
                            PageParts.Common.onClick <| Messages.SidebarMsg <| Messages.SidebarItemClicked <|Messages.NotLoadedPage strId url
                        ] -- todo: url must be passed to produced event
                    AlreadyLoaded name m -> SidebarEntry strId name []


        activeSubpageToSidebarEntry: ActiveSubpageData -> (String -> SidebarEntry Message)
        activeSubpageToSidebarEntry subpage =
            \strId ->
                SidebarEntry strId subpage.pageName []


        collectSidebarItems =
           List.indexedMap
                (\idx sbi -> sbi <| "sidebar-entry-" ++ String.fromInt idx)
                <| (
                        List.map inactiveSubpageToSidebarEntry model.inactiveSubpages
                        ++
                        [ activeSubpageToSidebarEntry model.activeSubpage ]
                   )


        sidebarModel =
           SidebarModel collectSidebarItems

    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                       ,text model.clicked
                    ]






--      READ DATA FROM FLAGS

type alias MainPageInitParams = {
        activeSubpageData: ActiveSubpageInitData
       ,inactiveSubpages: List InactiveSubpageInitData
    }

type alias InactiveSubpageInitData = {
       subpageName: String
      ,subpageUrl: String
    }

type alias ActiveSubpageInitData = {
       subpageName: String
      ,subpageInitParams: SubpageInitParams
   }

type SubpageInitParams =
          CreatePostPageInitParams CP.PageInitParams



--      DECODERS

-- create a decoder for each of SubpageInitParams
decodeCreatePostPageInitParams: Decoder SubpageInitParams
decodeCreatePostPageInitParams =
    Decode.oneOf [
            (Decode.map CreatePostPageInitParams CP.getDataFromFlags)
        ]

decodeActiveSubpageInitData: Decoder ActiveSubpageInitData
decodeActiveSubpageInitData =
    Decode.succeed ActiveSubpageInitData
          |> required "subpageName" Decode.string
          |> required "subpageInitParams" decodeCreatePostPageInitParams


decodeInactiveSubpageInitData: Decoder InactiveSubpageInitData
decodeInactiveSubpageInitData =
    Decode.succeed InactiveSubpageInitData
          |> required "subpageName" Decode.string
          |> required "subpageUrl" Decode.string

getDataFromFlags: Decoder MainPageInitParams
getDataFromFlags =
    Decode.succeed MainPageInitParams
        |> required "activeSubpageData" decodeActiveSubpageInitData
        |> optional "inactiveSubpages" (Decode.list decodeInactiveSubpageInitData) []




--      ERRORS

type Error =
     ModelInitErr String
   | UnknownPageType String String   -- first is page type, second - error message


errToString: Error -> String
errToString error =
    case error of
        ModelInitErr err -> err
        UnknownPageType pgName description -> "No such page " ++ pgName ++ " (" ++ description ++ ")"

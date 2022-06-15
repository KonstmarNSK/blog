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
        activeSubpage: SubpageModel
       ,inactiveSubpages: List InactiveSubpage
       ,clicked: String
    }

type InactiveSubpage =
     UrlOnly PageName PageUrl   -- contains its name and url which can be used to retrieve its data
   | AlreadyLoaded PageName SubpageModel


update: MainPageModel -> Message -> (MainPageModel, Cmd Message)
update mainPageModel message =
    case message of
        Messages.SidebarMsg (Messages.SidebarItemClicked (Messages.NotLoadedPage pageId pageUrl))  ->
            ({mainPageModel | clicked = "clicked on " ++ pageId ++ ", url is " ++ pageUrl}, Cmd.none)


draw: MainPageModel -> Element Message
draw model =
    let
        -- takes id of HTML element corresponding to this sidebar entry + entry itself
        inactiveSubpageToSidebarEntry: Int -> InactiveSubpage -> SidebarEntry Message
        inactiveSubpageToSidebarEntry elementId subpage =
            let strId = String.fromInt elementId in
            case subpage of
                UrlOnly name url -> SidebarEntry strId name [
                        PageParts.Common.onClick <| Messages.SidebarMsg <| Messages.SidebarItemClicked <|Messages.NotLoadedPage strId url
                    ] -- todo: url must be passed to produced event
                AlreadyLoaded name m -> SidebarEntry strId name []

        sidebarModel =
           SidebarModel
                (List.indexedMap inactiveSubpageToSidebarEntry model.inactiveSubpages)

    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                       ,text model.clicked
                    ]

type SubpageModel =
      CreatePostModel String PostCreationPageModel
    | ViewPostModel
    | ShowAllPostsModel


type alias ActivePageData = {
        page: SubpageModel
       ,pageName: String
    }


initModel: MainPageFlagsPart -> (MainPageModel, Cmd Message)
initModel mainPageFlagsPart =
    let
        activeSubpage = ViewPostModel
    in
    (
        MainPageModel
            activeSubpage
            (List.map (\subpage -> UrlOnly subpage.subpageName subpage.subpageUrl) mainPageFlagsPart.inactiveSubpages)
            "None"

        , Cmd.none
    )



--      READ DATA FROM FLAGS

type alias MainPageFlagsPart = {
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

getDataFromFlags: Decoder MainPageFlagsPart
getDataFromFlags =
    Decode.succeed MainPageFlagsPart
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

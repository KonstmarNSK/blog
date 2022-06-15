module Pages.MainPage exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Json.Decode as Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (required)
import Messages exposing (Message)
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarEntry)
import Pages.CreatePost as CP exposing (PostCreationPageModel)



--      MODEL

type alias MainPageModel = {
        activeSubpage: SubpageModel
    }


draw: MainPageModel -> Element Messages.Message
draw _ =
    let
        sidebarModel = SidebarModel [
                SidebarEntry "sb-entr-1" "First" []
               ,SidebarEntry "sb-entr-2" "Second" []
               ,SidebarEntry "sb-entr-3" "Third" []
            ]
    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
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
    (MainPageModel activeSubpage, Cmd.none)



--      READ DATA FROM FLAGS

type alias MainPageFlagsPart = {
        activeSubpageData: ActiveSubpageInitData
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


getDataFromFlags: Decoder MainPageFlagsPart
getDataFromFlags =
    Decode.succeed MainPageFlagsPart
        |> required "activeSubpageData" decodeActiveSubpageInitData


--      ERRORS

type Error =
     ModelInitErr String
   | UnknownPageType String String   -- first is page type, second - error message


errToString: Error -> String
errToString error =
    case error of
        ModelInitErr err -> err
        UnknownPageType pgName description -> "No such page " ++ pgName ++ " (" ++ description ++ ")"

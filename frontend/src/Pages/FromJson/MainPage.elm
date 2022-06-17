module Pages.FromJson.MainPage exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Pages.FromJson.CreatePostPage as CP exposing (PageInitParams)




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
          CreatePostPageInitParams PageInitParams



--      DECODERS

-- create a decoder for each of SubpageInitParams
decodeSubpageInitParams: Decoder SubpageInitParams
decodeSubpageInitParams =
    Decode.oneOf [
            (Decode.map CreatePostPageInitParams CP.getDataFromFlags)
        ]

decodeActiveSubpageInitData: Decoder ActiveSubpageInitData
decodeActiveSubpageInitData =
    Decode.succeed ActiveSubpageInitData
          |> required "subpageName" Decode.string
          |> required "subpageInitParams" decodeSubpageInitParams


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


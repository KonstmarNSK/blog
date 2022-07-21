module Pages.FromJson.MainPage exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Pages.FromJson.CreatePostPage as CP
import Pages.FromJson.ViewPost as VP




--      READ DATA FROM FLAGS

type alias MainPageInitParams = {
       apiUrlPrefix: String,
       pageUrlPrefix: String
    }


type SubpageInitParams =
    CreatePostPageInitParams CP.PageInitParams
  | ViewPostPageInitParams VP.ViewPostInitParams


--      DECODERS

getDataFromFlags: Decoder MainPageInitParams
getDataFromFlags =
    Decode.succeed MainPageInitParams
        |> required "api_root_addr" Decode.string
        |> required "page_root_addr" Decode.string


decodeSubpageData: Decoder SubpageInitParams
decodeSubpageData =
    Decode.oneOf [
        Decode.map CreatePostPageInitParams CP.fromJson
       ,Decode.map ViewPostPageInitParams VP.fromJson
    ]


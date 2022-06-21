module Pages.FromJson.MainPage exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Pages.Link exposing (Link)




--      READ DATA FROM FLAGS

type alias MainPageInitParams = {
       sidebarLinks: List Link
    }


--      DECODERS

getDataFromFlags: Decoder MainPageInitParams
getDataFromFlags =
    Decode.succeed MainPageInitParams
        |> required "sidebar-links" (Decode.list decodeLink)




decodeLink: Decoder Link
decodeLink =
    Decode.succeed Link
        |> required "url" Decode.string
        |> required "text" Decode.string


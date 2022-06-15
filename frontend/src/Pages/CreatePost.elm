module Pages.CreatePost exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Messages


--      MODEL

type alias PostCreationPageModel = {

 }


initModel: String -> PageInitParams -> Result Error PostCreationPageModel
initModel string properties =
    Ok PostCreationPageModel


draw: PostCreationPageModel -> Element Messages.Message
draw _ =
    el [] ( text "Me CreatePost Page!" )




--      READ DATA FROM FLAGS

type alias PageInitParams = {

    }


getDataFromFlags: Decoder PageInitParams
getDataFromFlags =
    Decode.succeed PageInitParams




--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str
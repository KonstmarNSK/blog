module Pages.CreatePost exposing (..)

import Element exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
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
        createPostSubmitUrl: String
    }


getDataFromFlags: Decoder PageInitParams
getDataFromFlags =
    Decode.succeed PageInitParams
        |> Json.Decode.Pipeline.required "createPostSubmitUrl" Decode.string



--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str
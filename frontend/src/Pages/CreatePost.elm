module Pages.CreatePost exposing (..)

import Element exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
import Messages
import Pages.FromJson.CreatePostPage exposing (PageInitParams)


--      MODEL

type alias PostCreationPageModel = {

 }


initModel: String -> PageInitParams -> Result Error PostCreationPageModel
initModel string properties =
    Ok PostCreationPageModel


view: PostCreationPageModel -> Element Messages.Message
view _ =
    el [] ( text "Me CreatePost Page!" )





--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str
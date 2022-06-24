module Pages.FromJson.CreatePostPage exposing (..)



--      READ DATA FROM FLAGS

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline



type alias PageInitParams = {
        createPostSubmitUrl: String
    }


getDataFromFlags: Decoder PageInitParams
getDataFromFlags =
    Decode.succeed PageInitParams
        |> Json.Decode.Pipeline.required "createPostSubmitUrl" Decode.string


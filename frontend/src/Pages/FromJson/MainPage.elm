module Pages.FromJson.MainPage exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Pages.Link exposing (Link)
import Pages.FromJson.CreatePostPage as CP




--      READ DATA FROM FLAGS

type alias MainPageInitParams = {
       createPostPageUrl: String
      ,viewAllPostsPageUrl: String
    }


type SubpageInitParams =
    CreatePostPageInitParams CP.PageInitParams


--      DECODERS

getDataFromFlags: Decoder MainPageInitParams
getDataFromFlags =
    Decode.succeed MainPageInitParams
        |> required "create-post-page-url" Decode.string
        |> required "view-all-posts-page-url" Decode.string


decodeSubpageData: Decoder SubpageInitParams
decodeSubpageData =
    Decode.oneOf [
        Decode.map CreatePostPageInitParams CP.getDataFromFlags
    ]


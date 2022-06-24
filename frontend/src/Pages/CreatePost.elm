module Pages.CreatePost exposing (..)

import Element exposing (..)
import Messages
import Pages.FromJson.CreatePostPage exposing (PageInitParams)
import Url exposing (Url)
import Pages.PagesModels.CreatePostPageModel exposing (PostCreationPageModel)


--      MODEL

initModel: String -> PageInitParams -> Result Error PostCreationPageModel
initModel string properties =
    Ok <| PostCreationPageModel "create-page-url"


view: PostCreationPageModel -> Element Messages.Message
view _ =
    el [] ( text "Me CreatePost Page!" )



isCreatePostPage: Url -> PostCreationPageModel -> Bool
isCreatePostPage url model =
        Url.toString url == model.pageUrl




--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str
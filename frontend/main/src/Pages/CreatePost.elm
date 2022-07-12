module Pages.CreatePost exposing (..)

import Element exposing (..)
import Messages
import Pages.FromJson.CreatePostPage exposing (PageInitParams)
import Url exposing (Url)
import Pages.PagesModels.CreatePostPageModel exposing (PostCreationPageModel)


--      MODEL

initModel: PageInitParams -> Result Error PostCreationPageModel
initModel properties =
    Ok <| PostCreationPageModel "create-page-url"


view: PostCreationPageModel -> Element Messages.Message
view _ =
    el [] ( text "Me CreatePost Page!" )



isCreatePostPage: Url -> PostCreationPageModel -> Bool
isCreatePostPage url model =
        Url.toString url == model.pageUrl

isSamePage: Url -> Url -> Bool
isSamePage url1 url2 = url1 == url2



--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str
module Pages.CreatePost exposing (..)

import Element exposing (..)
import Messages.Messages as Messages exposing (RequestResult(..))
import Messages.CreatePostPageMessages exposing (ReqResult(..))
import Pages.FromJson.CreatePostPage exposing (PageInitParams)
import Pages.HttpRequests.Common as ReqCommon
import Pages.Link as Link exposing (Link)
import Pages.PageType
import Url exposing (Url)
import Pages.PagesModels.CreatePostPageModel exposing (PostCreationPageModel)



--      MODEL

initModel: PageInitParams -> Result Error PostCreationPageModel
initModel properties =
    Ok <| PostCreationPageModel "create-page-url"


view: PostCreationPageModel -> Element Messages.Message
view _ =
    el [] ( text "Me CreatePost Page!" )



determinePageType: Url -> Maybe Pages.PageType.PageType
determinePageType url =
        case String.startsWith pathPrefix url.path of
            True -> Just Pages.PageType.CreatePost
            False -> Nothing


isSamePage: Url -> Url -> Bool
isSamePage url1 url2 = url1 == url2


-- todo: make type PageVersion instead of Int
loadPage: Link.ApiRootPrefix -> Int -> (Maybe PostCreationPageModel, Cmd Messages.Message)
loadPage apiPrefix pageVersion =
    (
        Nothing,
        ReqCommon.getCsrfToken apiPrefix (\response -> CreatePostReqResult <| CsrfTokenReqResult pageVersion response )
    )



{-
    Takes page host (ex. "http://some-host.domain/") and localized string (links' text) and returns Link that corresponds to this page
 -}
getPageLink: Link.PageRootPrefix -> Link.LinkText -> Maybe Link
getPageLink apiPrefix text =
    let
      strText = case text of Link.LinkText s -> s
      strApiPrefix = case apiPrefix of Link.PageRootPrefix s -> s

      url = Url.fromString <| strApiPrefix ++ pathPrefix
    in
        Maybe.map (\u -> Link u strText Pages.PageType.CreatePost) url


pathPrefix: String
pathPrefix = "create-post"



--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str



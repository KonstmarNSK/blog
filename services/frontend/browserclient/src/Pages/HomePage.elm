module Pages.HomePage exposing (..)


import Element exposing (..)
import Messages.Messages as Messages
import Pages.HttpRequests.Common as ReqCommon
import Pages.Link as Link exposing (Link)
import Pages.PageType
import Url exposing (Url)





determinePageType: Url -> Maybe Pages.PageType.PageType
determinePageType url =
        case url.path == "" of
            True -> Just Pages.PageType.Home
            False -> Nothing


isSamePage: Url -> Url -> Bool
isSamePage url1 url2 = url1 == url2


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
        Maybe.map (\u -> Link u strText Pages.PageType.Home) url


pathPrefix: String
pathPrefix = ""



view: Element Messages.Message
view =
    el [] ( text "Me home Page!" )


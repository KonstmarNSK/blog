module Pages.ShowAllPosts exposing (..)


import Pages.Link as Link exposing (Link)
import Pages.PageType
import Url exposing (Url)


getPageLink: Link.PageRootPrefix -> Link.LinkText -> Maybe Link
getPageLink apiPrefix text =
    let
      strText = case text of Link.LinkText s -> s
      strApiPrefix = case apiPrefix of Link.PageRootPrefix s -> s

      url = Url.fromString <| strApiPrefix ++ pathPrefix
    in
        Maybe.map (\u -> Link u strText Pages.PageType.ViewAllPosts) url


pathPrefix: String
pathPrefix = "view-all-posts"



determinePageType: Url -> Maybe Pages.PageType.PageType
determinePageType url =
        case String.startsWith pathPrefix url.path of
            True -> Just Pages.PageType.ViewAllPosts
            False -> Nothing


isSamePage: Url -> Url -> Bool
isSamePage url1 url2 = url1 == url2
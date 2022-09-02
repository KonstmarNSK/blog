module Pages.HomePage exposing (..)


import Element exposing (..)
import Pages.Link as Link exposing (Link)
import Url exposing (Url)


type HomePagesState = HomePagesState
type PageMessage = PageMsg

initState = HomePagesState


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

      url = Url.fromString <| strApiPrefix
    in
        Maybe.map (\u -> Link u strText ) url


loadPage: Url -> (PageMessage -> tMsg) -> HomePagesState -> Maybe (HomePagesState, Cmd tMsg)
loadPage url msgMapper homePagesState =
    case isHomepageUrl url of
        True -> Just (homePagesState, Cmd.none)
        False -> Nothing

processLoadedPart: PageMessage -> HomePagesState -> Result Error HomePagesState
processLoadedPart pageMessage commonState =
    Ok commonState


isHomepageUrl: Url -> Bool
isHomepageUrl url = String.isEmpty url.path


view: HomePagesState -> Element tMsg
view _ =
    el [] ( text "Me home Page!" )


type Error =
    Error







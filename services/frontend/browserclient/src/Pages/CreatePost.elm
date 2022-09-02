module Pages.CreatePost exposing (..)

import Element exposing (..)
import Pages.Link as Link exposing (Link)
import Url exposing (Url)



--      MODEL

type PageMessage =
    LoadedPart

-- common for all pages of type 'Create Post'
type CommonState =
    CommonState {
        activePage: Model
        -- todo: add cache
    }

initCommonState: CommonState
initCommonState =
    CommonState {
            activePage = Model
        }

type Model = Model



view: CommonState -> Element tMsg
view _ =
    el [] ( text "Me CreatePost Page!" )


loadPage: Url -> (PageMessage -> tMsg) -> CommonState -> Maybe (CommonState, Cmd tMsg)
loadPage url msgMapper createPostCommonState =
    case String.startsWith pathPrefix url.path of
        True -> Just (
                    createPostCommonState
                   ,Cmd.none
                )

        False -> Nothing


processLoadedPart: PageMessage -> CommonState -> Result Error CommonState
processLoadedPart pageMessage commonState =
    Ok commonState


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
        Maybe.map (\u -> Link u strText) url


pathPrefix: String
pathPrefix = "create-post"



--      ERRORS

type Error =
    ModelInitErr String

errToString: Error -> String
errToString err =
    case err of
        ModelInitErr str -> str



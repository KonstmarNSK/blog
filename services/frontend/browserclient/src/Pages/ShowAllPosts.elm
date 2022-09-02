module Pages.ShowAllPosts exposing (..)


import Element exposing (..)
import Pages.Link as Link exposing (Link)
import Url exposing (Url)







type PageMessage =
    LoadedPart

-- common for all pages of type 'Show all posts'
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
    el [] ( text "Me ShowAll Page!" )


loadPage: Url -> (PageMessage -> tMsg) -> CommonState -> (CommonState, Cmd tMsg)
loadPage url msgMapper commonState =
    (
        commonState
       ,Cmd.none
    )



getPageLink: Link.PageRootPrefix -> Link.LinkText -> Maybe Link
getPageLink apiPrefix text =
    let
      strText = case text of Link.LinkText s -> s
      strApiPrefix = case apiPrefix of Link.PageRootPrefix s -> s

      url = Url.fromString <| strApiPrefix ++ pathPrefix
    in
        Maybe.map (\u -> Link u strText) url


pathPrefix: String
pathPrefix = "view-all-posts"

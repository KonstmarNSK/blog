module Pages.ViewPost exposing (..)


import Element exposing (..)
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
    el [] ( text "Me ViewPost Page!" )


loadPage: Url -> (PageMessage -> tMsg) -> CommonState -> (CommonState, Cmd tMsg)
loadPage url msgMapper commonState =
    (
        commonState
       ,Cmd.none
    )
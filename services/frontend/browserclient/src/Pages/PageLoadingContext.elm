module Pages.PageLoadingContext exposing (..)


import Http
import Pages.Csrf exposing (..)
import Pages.HttpRequests.Common exposing (HttpRequest)



type LoadingStage err val =
    LoadedPart (Result err val)
  | PendingPart


-- Represents either partially or completely loaded page; pgState is the type of completely loaded page state
type ContextLoadingState err pgState =
    LoadedPage (Result err pgState)
  | PartiallyLoadedPage PageLoadingContext


type CreatePageLoadingError = CreatePageLoadingError



type PageLoadingContextId = PageLoadingContextId Int

type PageLoadingContext =
    CreatePostPageLoadingContext (LoadingStage CreatePageLoadingError CsrfToken)




-- todo: rename
type alias PageLoadingContextIntoPageModel tErr tModel= (PageLoadingContext -> ContextLoadingState tErr tModel)




-- a function that takes http response with already created loading context and returns either loading context or the whole page state
type alias PageLoadedPartProcessor tMsg err pageState = (tMsg -> PageLoadingContext -> ContextLoadingState err pageState)


type PageLoadingRequest tMsg err pageState =
    PageLoadingRequest (
            List (HttpRequest, Http.Expect tMsg)
           ,PageLoadingContext
           ,PageLoadedPartProcessor tMsg err pageState
        )


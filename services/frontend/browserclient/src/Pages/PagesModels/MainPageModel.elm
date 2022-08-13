module Pages.PagesModels.MainPageModel exposing (..)

import Dict exposing (Dict)
import Pages.Link exposing (Link)
import Pages.PagesModels.CreatePostPageModel exposing (PostCreationPageModel)
import Pages.PagesModels.LoadingPageModel as L
import Pages.PagesModels.ViewPostPageModel exposing (ViewPostPageModel)
import Url exposing (Url)
import Pages.PageType as PT
import Pages.ActivePageVersion as PageVer
import Pages.PageLoadingContext as PLC



type alias MainPageModel = {
        sidebarLinks: List Link
       ,alreadyLoadedPages: AlreadyLoadedPages
       ,activeSubpage: ActiveSubpage
       ,apiUrlPrefix: Pages.Link.ApiRootPrefix
       ,pageRootPrefix: Pages.Link.PageRootPrefix
       ,loadingPageContexts: Dict PLC.PageLoadingContextId PLC.PageLoadingContext
       ,nextPageLoadingContextId: PLC.PageLoadingContextId
    }



type ActiveSubpage = ActiveSubpage { page:  AlreadyLoadedPage, version: PageVer.ActivePageVersion }

type AlreadyLoadedPages =
    AlreadyLoadedPages { activeSubpage: ActiveSubpage, alreadyLoadedPages: List AlreadyLoadedPage}
  | EmptyAlreadyLoadedPages

type AlreadyLoadedPage = AlreadyLoadedPage { pageType: PT.PageType, url: PageUrl PT.PageType, pageModel: SubpageModel }


type PageUrl pageType =
    PageUrl pageType Url


pageUrlIntoUrl: PageUrl t -> Url
pageUrlIntoUrl pageUrl =
    case pageUrl of
        PageUrl _ u -> u



type SubpageModel =
      CreatePostModel PostCreationPageModel
    | ViewPostModel ViewPostPageModel
    | ShowAllPostsModel
    | LoadingPageModel L.LoadingPageModel
    | HomePageModel





--      ERRORS

type Error =
     ModelInitErr String
   | UnknownPageType String String   -- first is page type, second - error message
   | SeveralPagesWithSameUrl String


errToString: Error -> String
errToString error =
    case error of
        ModelInitErr err -> err
        UnknownPageType pgName description -> "No such page " ++ pgName ++ " (" ++ description ++ ")"
        SeveralPagesWithSameUrl url -> "Found several pages with same url: " ++ url

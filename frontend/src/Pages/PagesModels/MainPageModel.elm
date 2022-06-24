module Pages.PagesModels.MainPageModel exposing (..)

import Pages.Link exposing (Link)
import Pages.PagesModels.CreatePostPageModel exposing (PostCreationPageModel)
import Pages.PagesModels.LoadingPageModel as L
import Url exposing (Url)



type alias MainPageModel = {
        sidebarLinks: List Link
       ,text: String
       ,alreadyLoadedPages: List AlreadyLoadedPage
       ,activeSubpage: ActiveSubpage
       ,subpagesUrls: {
            createPostPageUrl: String,
            viewAllPostsPageUrl: String
        }
    }


type alias ActiveSubpage = {
        url: Url
       ,subpageModel: SubpageModel
    }

type alias AlreadyLoadedPage = {
        pgModel: SubpageModel,
        url: String
    }


type SubpageModel =
      CreatePostModel PostCreationPageModel
    | ViewPostModel
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

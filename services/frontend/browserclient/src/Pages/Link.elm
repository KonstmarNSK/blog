module Pages.Link exposing (..)

type alias Link = {
        url: String
       ,text: String
       ,pageType: PageType
    }

type PageType =
    CreatePost
  | ViewAllPosts
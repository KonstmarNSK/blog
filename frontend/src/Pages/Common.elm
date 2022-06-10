module Pages.Common exposing (..)


import Element exposing (Element)
import Messages


type alias Page pageType modelType = {
        pageType: pageType
        ,showPage: modelType -> Element Messages.Message
    }



type PageType =
    MainPage
    | CreatePost
    | ViewPost
    | ShowAllPosts
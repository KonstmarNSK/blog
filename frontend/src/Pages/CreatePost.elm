module Pages.CreatePost exposing (..)

import Element exposing (..)
import Messages
import Pages.Common as C exposing (PageType, Page)




type alias PostCreationPageModel = {

 }


page: C.Page (C.PageType) (PostCreationPageModel)
page = C.Page (C.CreatePost) (draw)


draw: PostCreationPageModel -> Element Messages.Message
draw _ =
    el [] ( text "Me CreatePost Page!" )
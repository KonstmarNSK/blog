module Pages.MainPage exposing (..)

import Element exposing (..)
import Element.Font as Font
import Messages
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarEntry)
import Pages.Common as C exposing (PageType, Page)



type alias MainPageModel = {

    }


page: C.Page (C.PageType) (MainPageModel)
page = C.Page (C.MainPage) (draw)



draw: MainPageModel -> Element Messages.Message
draw _ =
    let
        sidebarModel = SidebarModel [
                SidebarEntry "sb-entr-1" "First" []
               ,SidebarEntry "sb-entr-1" "Second" []
               ,SidebarEntry "sb-entr-1" "Third" []
            ]
    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                    ]

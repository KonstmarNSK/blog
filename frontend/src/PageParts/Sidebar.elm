module PageParts.Sidebar exposing (sidebar, SidebarLink, SidebarModel)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Messages exposing (Message)
import PageParts.Common as C





type alias SidebarLink msgType = {
       url: String
       ,name: String     -- string that wll appear in the sidebar
       ,producingEvents: List (C.ElementEvent msgType)  -- events that this entry will produce
    }


type alias SidebarModel msg = {
        entries: List (SidebarLink msg)
    }



sidebar: SidebarModel Message -> Element Message
sidebar model =
    let
        links: SidebarLink Message-> Element Message
        links e =
            el
                ([] ++ List.map C.toAttribute e.producingEvents)
                (link [] { url = e.url, label = (text e.name)} )

    in
    column
            [ height fill
            , width <| maximum 250 <| fillPortion 1
            , paddingXY 0 10
            , scrollbarY
            , Background.color <| rgb255 0x2E 0x34 0x36
            , Font.color <| rgb255 0xFF 0xFF 0xFF
            ]
        <|
            List.map links model.entries



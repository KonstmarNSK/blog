module PageParts.Sidebar exposing (sidebar, SidebarLink, SidebarModel)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font




type alias SidebarLink = {
       url: String
       ,name: String     -- string that wll appear in the sidebar
       --,producingEvents: List (C.ElementEvent msgType)  -- events that this entry will produce
    }


type alias SidebarModel = {
        entries: List (SidebarLink)
    }



sidebar: SidebarModel -> Element tMsg
sidebar model =
    let
        links: SidebarLink-> Element tMsg
        links e =
            el
                ([paddingXY 20 10])
                (link [] { url = e.url, label = (text e.name)} )

    in
    column
            [ height fill
            , width <| maximum 200 <| fillPortion 1
            , paddingXY 0 10
            , scrollbarY
            , Background.color <| rgb255 0x2E 0x34 0x36
            , Font.color <| rgb255 0xFF 0xFF 0xFF
            ]
        <|
            List.map links model.entries



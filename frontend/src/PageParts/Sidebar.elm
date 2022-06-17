module PageParts.Sidebar exposing (sidebar, SidebarEntry, SidebarModel)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Messages exposing (Message)
import PageParts.Common as C





type alias SidebarEntry msgType = {
        id: String       -- id of its HTML element
       ,name: String     -- string that wll appear in the sidebar
       ,producingEvents: List (C.ElementEvent msgType)  -- events that this entry will produce
    }


type alias SidebarModel msg = {
        entries: List (SidebarEntry msg)
    }



sidebar: SidebarModel Message -> Element Message
sidebar model =
    let
        entry: SidebarEntry Message-> Element Message
        entry e =
            el
                ([] ++ List.map C.toAttribute e.producingEvents)
                (text <| e.name)

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
            List.map entry model.entries



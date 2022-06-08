-- basically stolen from https://korban.net/elm/elm-ui-patterns/chat-layout

module PageParts.Sidebar exposing (sidebar)

import Element exposing (..)
import Element.Events as Events
import Messages exposing (Message, SidebarMsg(..))
import Model

import Element.Background as Background
import Element.Font as Font


sidebar: Model.Model -> Element Message
sidebar _ =
        channelPanel sampleChannels sampleActiveChannel


channelPanel : List String -> String -> Element Message
channelPanel channels activeChannel =
    let
        activeChannelAttrs =
            [ Background.color color.blue, Font.bold, Font.color color.white ]

        channelAttrs =
            [ width fill, paddingXY 10 5 ]

        channelEl channel =
            el
                (if channel == activeChannel then
                    activeChannelAttrs ++ channelAttrs

                 else
                    channelAttrs
                )
            <|
            el [Events.onClick <| Messages.SidebarMsg SidebarItemClicked] (text ("# " ++ channel))

    in
    column
        [ height fill
        , width <| maximum 250 <| fillPortion 1
        , paddingXY 0 10
        , scrollbarY
        , Background.color color.darkCharcoal
        , Font.color color.white
        ]
    <|
        List.map channelEl channels



sampleChannels : List String
sampleChannels =
    [ "beginners"
    , "core-coordination"
    , "ellie"
    , "elm-community"
    , "elm-discuss"
    , "elm-format"
    , "elm-markdown"
    , "elm-ui"
    , "general"
    , "jobs"
    , "news-and-links"
    ]


sampleActiveChannel : String
sampleActiveChannel =
    "elm-ui"


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    }





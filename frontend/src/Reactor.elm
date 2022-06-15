module Reactor exposing (..)

import Browser
import Flags as F exposing (Flags)
import Json.Encode as Encode
import Messages exposing (Message)
import Model
import Main exposing (..)
import Dict exposing (Dict)

main = mainForReactor

-- mainForReactor, defaultFlags and defaultInit are needed for launch via 'elm reactor' (entry point is Reactor.elm)
mainForReactor =
  Browser.element
    { init = defaultInit
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

defaultFlags = Encode.object [
    ( "activeSubpageData", Encode.object [
        ("subpageName", Encode.string "Create post!")
       ,("subpageInitParams", Encode.object [
                -- nothing
       ])
    ])
  ]


defaultInit: Flags -> (Model.Model, Cmd Message)
defaultInit flags = Main.init flags

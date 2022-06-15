module Reactor exposing (..)

import Browser
import Flags as F exposing (Flags)
import Json.Encode as Encode exposing (..)
import Messages exposing (Message)
import Model
import Main exposing (..)

main = mainForReactor

-- mainForReactor, defaultFlags and defaultInit are needed for launch via 'elm reactor' (entry point is Reactor.elm)
mainForReactor =
  Browser.element
    { init = defaultInit
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

defaultFlags = object [
    ( "activeSubpageData", object [
        ("subpageName", string "Create post!")
       ,("subpageInitParams", object [
                ("createPostSubmitUrl", string "some http url")
       ])
    ])
    ,
    ("inactiveSubpages", list object [
            [
                ("subpageName", (string "View post"))
               ,("subpageUrl", string "some-url-1")
            ]
            ,
            [
                ("subpageName", (string "Show all posts"))
               ,("subpageUrl", string "some-url-2")
            ]
        ])
  ]


defaultInit: Flags -> (Model.Model, Cmd Message)
defaultInit _ = Main.init defaultFlags

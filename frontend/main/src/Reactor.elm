module Reactor exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation
import Flags as F exposing (Flags)
import Json.Encode as Encode exposing (..)
import Messages exposing (MainPageMessage(..), Message)
import Model
import Main exposing (..)
import Url exposing (Url)

main = mainForReactor

-- mainForReactor, defaultFlags and defaultInit are needed for launch via 'elm reactor' (entry point is Reactor.elm)
mainForReactor =
  Browser.application
    { init = defaultInit
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlRequest = \url -> Messages.MPMessage <| LinkClicked url
    , onUrlChange = \url -> Messages.MPMessage <| UrlChanged url
    }

defaultFlags = object [
    ("base-url", string "http://localhost:8000/src"),   -- using this instead of window.location
    ("create-post-page-url", string "some-create-post-page-url.json"),
    ("view-all-posts-page-url", string "some-view-all-posts-page-url.json")
  ]

defaultInit: Flags -> Url -> Navigation.Key  -> (Model.Model, Cmd Message)
defaultInit _ url key  = Main.init defaultFlags url key
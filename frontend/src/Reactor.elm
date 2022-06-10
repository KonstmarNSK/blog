module Reactor exposing (..)

import Browser
import Flags as F
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

defaultFlags = F.Flags
    (F.CreatePostComponent "a" "b")
    (F.GetAllPostsComponent "a" "b")
    (F.ReadSpecificPostComponent "a" "b")

defaultInit: () -> (Model.Model, Cmd Message)
defaultInit _ = (Model.Model, Cmd.none)
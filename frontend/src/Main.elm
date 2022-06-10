module Main exposing (..)

import Browser
import Element exposing (fill, height, layout, width)
import Html exposing (..)
import Messages exposing (Message(..))
import Pages.MainPage as MP

import Model
import Flags exposing (..)


-- MAIN

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init : Flags -> (Model.Model, Cmd Message)
init flags =
  (
    Model.Model,
    Cmd.none
  )






-- UPDATE


update : Message -> Model.Model -> (Model.Model, Cmd Message)
update msg model =
  case msg of
    SidebarMsg _ -> (model, Cmd.none)








-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Message
subscriptions _ =
    Sub.none






-- VIEW


view : Model.Model -> Html Message
view model =
    layout [ width fill, height fill ] <|
        MP.draw MP.MainPageModel

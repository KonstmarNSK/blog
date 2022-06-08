module Main exposing (..)

import Browser
import Element exposing (el, fill, height, layout, minimum, row, width)
import Element.Font as Font
import Html exposing (..)
import Messages exposing (Message(..))
import PageParts.Sidebar exposing (sidebar)
import Time
import Http

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
    Model.defaultModel flags,
    Cmd.none
  )






-- UPDATE


update : Message -> Model.Model -> (Model.Model, Cmd Message)
update msg model =
  case msg of
    DoRequest _ ->
        (
            model,
            Http.get
                { url = (Model.getFlags model).getAllPostsComponent.getAllPostsUrl
                , expect = Http.expectString GotText
                }
        )

    GotText result ->
        case result of
            Ok links -> ((Model.withPostsList model links), Cmd.none)
            Err _ -> ((Model.withPostsList model "There was an error..."), Cmd.none)

    SidebarMsg _ -> ((Model.setClicked model "Yes"), Cmd.none)








-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Message
subscriptions _ =
    Sub.batch [
        Time.every (5 * 1000) DoRequest
    ]








-- VIEW


view : Model.Model -> Html Message
view model =
    layout [ width fill, height fill ] <|
            row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                [
                    sidebar model
                    , el [] <| Element.text <| Model.getClicked model
                ]
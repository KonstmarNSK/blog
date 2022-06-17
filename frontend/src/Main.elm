module Main exposing (..)

import Browser
import Element exposing (fill, height, layout, width)
import Html exposing (..)
import Json.Decode
import Messages exposing (Message(..))
import Pages.FromJson.MainPage as MP
import Pages.MainPage as MP

import Model


-- MAIN

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init : Json.Decode.Value -> (Model.Model, Cmd Message)
init flags =
    let
        -- let MainPage decode its initial parameters
        decodedFlags = Json.Decode.decodeValue MP.getDataFromFlags flags
    in
        case decodedFlags of
            Ok val -> case MP.initModel val of
                Ok (m, cmd) -> (Model.Correct {mainPageModel = m}, cmd)
                Err e -> (Model.Incorrect <| Model.IncorrectFlags <| MP.errToString e, Cmd.none)

            Err e ->
                (Model.Incorrect <| Model.IncorrectFlags <| "Flags are incorrect! " ++ (Json.Decode.errorToString e) , Cmd.none)





-- UPDATE


update : Message -> Model.Model -> (Model.Model, Cmd Message)
update msg model =
  case msg of
    MPMessage _ ->
        case model of
            Model.Correct correctModel ->
                case MP.update correctModel.mainPageModel msg of
                    (m, c) ->
                        (Model.Correct {correctModel | mainPageModel = m }, c)

            _ ->        (model, Cmd.none)








-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Message
subscriptions _ =
    Sub.none






-- VIEW


view : Model.Model -> Html Message
view model =
    let
       drawErr error =
            Element.el [] (Element.text <| Model.errToString error)

       body = case model of
           Model.Correct m -> MP.view m.mainPageModel
           Model.Incorrect err -> drawErr err
    in
    layout [ width fill, height fill ] <|
        body





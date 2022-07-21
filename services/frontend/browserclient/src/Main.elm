module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Element exposing (fill, height, layout, width)
import Browser.Navigation as Nav
import Json.Decode
import Messages.Messages as Messages exposing (MainPageMessage(..), Message(..))
import Pages.FromJson.MainPage as MP
import Pages.MainPage as MP
import Pages.PagesModels.MainPageModel as MPM

import Model
import Url exposing (Url)


-- MAIN

main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlRequest = \url -> Messages.MPMessage <| LinkClicked url
    , onUrlChange = \url -> Messages.MPMessage <| UrlChanged url
    }


init : Json.Decode.Value -> Url.Url -> Nav.Key -> (Model.Model, Cmd Message)
init flags url _ =
    let
        -- let MainPage decode its initial parameters
        decodedFlags = Json.Decode.decodeValue MP.getDataFromFlags flags
    in
        case decodedFlags of
            Ok val -> case MP.initModel val url of
                Ok (m, cmd) -> (Model.Correct {mainPageModel = m}, cmd)
                Err e -> (Model.Incorrect <| Model.IncorrectFlags <| MPM.errToString e, Cmd.none)

            Err e ->
                (Model.Incorrect <| Model.IncorrectFlags <| "Flags are incorrect! " ++ (Json.Decode.errorToString e) , Cmd.none)



-- UPDATE


update : Message -> Model.Model -> (Model.Model, Cmd Message)
update msg model =
        case model of
            Model.Correct correctModel ->
                case msg of
                    MPMessage mpMessage ->
                        case MP.update correctModel.mainPageModel mpMessage of
                            (m, c) ->
                                (Model.Correct {correctModel | mainPageModel = m }, c)

            _ -> (model, Cmd.none)





-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Message
subscriptions _ =
    Sub.none






-- VIEW


view : Model.Model -> Document Message
view model =
    let
       drawErr error =
            Element.el [] (Element.text <| Model.errToString error)

       body = case model of
           Model.Correct m -> MP.view m.mainPageModel
           Model.Incorrect err -> drawErr err
    in

    Document "SomeTitle" [
        layout [ width fill, height fill ] <|
            body
    ]





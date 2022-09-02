module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Element exposing (fill, height, layout, width)
import Browser.Navigation as Nav
import Json.Decode
import Pages.MainPage as MP
import Url exposing (Url)




main =
  Browser.application
    {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions,
        onUrlRequest = UrlRequested,
        onUrlChange = UrlChanged
    }




type MainMsg =
    UrlRequested UrlRequest
  | UrlChanged Url
  | MPMessage MP.MPMessage


type MainModel =
    CorrectMainModel { mainPageModel: MP.MPModel }
  | IncorrectMainModel { errors: List Error }

type Error =
    MainPageError MP.Error
  | IncorrectFlags String


--  FUNCTIONS

mpMsgIntoMainMsg: MP.MPMessage -> MainMsg
mpMsgIntoMainMsg mpMsg = MPMessage mpMsg

errorToString: Error -> String
errorToString error =
    case error of
        MainPageError mpErr -> MP.errorToString mpErr
        IncorrectFlags msg -> "Incorrect flags. " ++ msg


init : Json.Decode.Value -> Url.Url -> Nav.Key -> (MainModel, Cmd MainMsg)
init flags url _ =
    let
        -- let MainPage decode its initial parameters
        decodedFlags = Json.Decode.decodeValue MP.getInitDataFromJson flags
    in
        case decodedFlags of
            Ok val ->
                case MP.initModel val url of
                    Ok (m, cmd) -> (CorrectMainModel {mainPageModel = m}, Cmd.map mpMsgIntoMainMsg cmd)
                    Err e -> (IncorrectMainModel { errors = [MainPageError e]}, Cmd.none)

            Err e ->
                (IncorrectMainModel { errors = [IncorrectFlags <| "Flags are incorrect! " ++ (Json.Decode.errorToString e)]} , Cmd.none)



update : MainMsg -> MainModel -> (MainModel, Cmd MainMsg)
update msg model =
    case (model, msg) of
        (CorrectMainModel fields, MPMessage mpMessage) ->
            case MP.update fields.mainPageModel mpMessage mpMsgIntoMainMsg of
                (m, c) ->
                    (CorrectMainModel { fields | mainPageModel = m }, c)

        (CorrectMainModel _, _) -> (model, Cmd.none) -- fixme: process UrlClicked

        (IncorrectMainModel _, _) -> (model, Cmd.none)




view : MainModel -> Document MainMsg
view model =
    case model of
        CorrectMainModel fields ->
            Document "SomeTitle" [
                layout [ width fill, height fill ] <|
                    Element.map mpMsgIntoMainMsg (MP.view fields.mainPageModel)
            ]

        IncorrectMainModel fields ->
            Document "Error :(" [
                layout [ width fill, height fill ] <|
                    Element.text <| "Errors were encountered: " ++ (String.concat <| List.map errorToString fields.errors)
            ]



subscriptions : MainModel -> Sub MainMsg
subscriptions _ =
    Sub.none




module Messages.Messages exposing (..)


import Browser exposing (UrlRequest)
import Http
import Messages.CreatePostPageMessages as CPMessages
import Url exposing (Url)


type Message =
   MPMessage MainPageMessage

type MainPageMessage =
    LinkClicked UrlRequest
    | UrlChanged Url
    | GotHttpRequestResult (Result Http.Error RequestResult)


type RequestResult =
    CreatePostReqResult CPMessages.ReqResult
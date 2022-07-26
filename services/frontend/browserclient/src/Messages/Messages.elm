module Messages.Messages exposing (..)


import Browser exposing (UrlRequest)
import Http
import Messages.CreatePostPageMessages as CPMessages
import Url exposing (Url)
import Pages.ActivePageVersion as PageVer


type Message =
   MPMessage MainPageMessage

type MainPageMessage =
    LinkClicked UrlRequest
    | UrlChanged Url
    | GotPageInfoRequestResult PageVer.ActivePageVersion (Result Http.Error RequestResult)


type RequestResult =
    CreatePostReqResult CPMessages.ReqResult
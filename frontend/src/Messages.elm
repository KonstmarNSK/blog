module Messages exposing (..)


import Browser exposing (UrlRequest)
import Url exposing (Url)


type Message =
   MPMessage MainPageMessage

type MainPageMessage =
    LinkClicked UrlRequest
    | UrlChanged Url


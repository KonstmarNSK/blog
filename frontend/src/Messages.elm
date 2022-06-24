module Messages exposing (..)


import Browser exposing (UrlRequest)
import Http
import Pages.FromJson.MainPage as MainPageModel
import Pages.SubpageUrl exposing (SubpageUrl)
import Url exposing (Url)


type Message =
   MPMessage MainPageMessage

type MainPageMessage =
    LinkClicked UrlRequest
    | UrlChanged Url
    | GotPageInfo SubpageUrl (Result Http.Error MainPageModel.SubpageInitParams)


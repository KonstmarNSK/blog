module Model exposing (..)


import Pages.MainPage as MP


type Model =
      Correct CorrectModel
    | Incorrect Error

type alias CorrectModel = { mainPageModel: MP.MainPageModel }

type Error =
    IncorrectFlags String

errToString: Error -> String
errToString error =
    case error of
        IncorrectFlags desc -> desc






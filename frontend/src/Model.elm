module Model exposing (..)


import Pages.MainPage as MP


type Model =
      Correct { mainPageModel: MP.MainPageModel }
    | Incorrect Error


type Error =
    IncorrectFlags String

errToString: Error -> String
errToString error =
    case error of
        IncorrectFlags desc -> desc






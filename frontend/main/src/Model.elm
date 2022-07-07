module Model exposing (..)


import Pages.PagesModels.MainPageModel as MP


type Model =
      Correct CorrectModel
    | Incorrect Error

type alias CorrectModel = { mainPageModel: MP.MainPageModel }



type Error =
    IncorrectFlags String
  | MPError MP.Error


mpErrorToError: MP.Error -> Error
mpErrorToError mpErr =
    MPError mpErr


errToString: Error -> String
errToString error =
    case error of
        IncorrectFlags desc -> desc
        MPError err -> MP.errToString err






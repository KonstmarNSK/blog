module Model exposing (Model, defaultModel, getFlags, withPostsList, getPostsList, getClicked, setClicked)

import Flags exposing (Flags)


type Model =
  Model Internal

type alias Internal = {
        flags: Flags
        ,postsList: String
        ,clicked: String
    }

defaultModel: Flags -> Model
defaultModel flags =
    Model (Internal flags "default" "No")


getFlags: Model -> Flags
getFlags model =
    case model of
        Model internal -> internal.flags

getPostsList: Model -> String
getPostsList model =
    case model of
        Model internal -> internal.postsList

getClicked model =
    case model of
        Model internal -> internal.clicked

setClicked model clicked =
    case model of
        Model internal -> Model {internal | clicked = clicked}

withPostsList: Model -> String -> Model
withPostsList model postsList =
    case model of
        Model internal -> Model {internal | postsList = postsList}










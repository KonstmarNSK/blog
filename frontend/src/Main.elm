module Main exposing (..)

import Browser
import Html exposing (..)
import Time
import Http



-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  {
    getPostsListUrl: String
   ,postsList: String
  }


init : String -> (Model, Cmd Msg)
init getPostsListUrl =
  (
    Model getPostsListUrl "",
    Cmd.none
  )



-- UPDATE


type Msg
  = DoRequest Time.Posix
  | GotText (Result Http.Error String)



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    DoRequest _ ->
        (
            model,
            Http.get
                { url = model.getPostsListUrl
                , expect = Http.expectString GotText
                }
        )

    GotText result ->
        case result of
            Ok links -> ({ model | postsList = links}, Cmd.none)
            Err _ -> ({ model | postsList = "There was an error..."}, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [
        Time.every (5 * 1000) DoRequest
    ]



-- VIEW


view : Model -> Html Msg
view model =
  div[][
    p [] [ text (model.postsList) ]
  ]

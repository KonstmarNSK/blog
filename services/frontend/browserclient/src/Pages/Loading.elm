module Pages.Loading exposing (..)

import Element exposing (..)
import Messages.Messages exposing (Message)
import Pages.PagesModels.LoadingPageModel exposing (LoadingPageModel)




view: LoadingPageModel -> Element Message
view model =
    row [ width fill, centerY, centerX] [
        column [centerY, centerX] [
            row [centerX, padding 20] [text "Loading..."],

            image [width <| maximum 100 fill]
                {
                    src = "assets/spinner.jpg"
                    , description = "Loading..."
                }
        ]
    ]





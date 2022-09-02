module Pages.Loading exposing (..)

import Element exposing (..)


view: Element tMsg
view =
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





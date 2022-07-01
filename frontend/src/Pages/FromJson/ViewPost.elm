module Pages.FromJson.ViewPost exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline


type alias ViewPostInitParams = {}



fromJson: Decoder ViewPostInitParams
fromJson =
    Decode.succeed ViewPostInitParams


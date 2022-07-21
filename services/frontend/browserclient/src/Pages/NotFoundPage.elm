module Pages.NotFoundPage exposing (..)

import Url exposing (Url)

isSamePage: Url -> Url -> Bool
isSamePage url1 url2 = url1 == url2
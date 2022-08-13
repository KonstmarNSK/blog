module Pages.HttpRequests.Common exposing (..)

import Dict exposing (Dict)
import Url exposing (Url)


type HttpRequest =
    HttpRequest Url HttpMethodWithParams

type HttpMethodWithParams =
    HttpGetWithParams QueryParams

type QueryParams =
    EmptyQueryParams
  | QueryParams (Dict String String)













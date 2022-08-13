module Pages.HttpRequests.Urls exposing (..)


import Url exposing (Url)
import Pages.Link as Lnk




loadingPageSpinnerImgUrl: Lnk.PageRootPrefix -> Maybe Url
loadingPageSpinnerImgUrl pageUrlPrefix =
    case pageUrlPrefix of
        Lnk.PageRootPrefix str -> Url.fromString (str ++ "assets/spinner.jpg")



csrfTokenGetUrl: Lnk.ApiRootPrefix -> Maybe Url
csrfTokenGetUrl apiUrlPrefix =
    case apiUrlPrefix of
        Lnk.ApiRootPrefix str -> Url.fromString (str ++ "/get-csrf-token")

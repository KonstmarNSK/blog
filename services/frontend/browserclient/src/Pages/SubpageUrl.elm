module Pages.SubpageUrl exposing (..)

import Url exposing (Url)
import Pages.Link exposing (PageType)



type alias SubpageUrl = { pageType: PageType, url: Url }
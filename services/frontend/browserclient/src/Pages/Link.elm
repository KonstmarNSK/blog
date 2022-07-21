module Pages.Link exposing (..)

import Url exposing (Url)
import Pages.PageType exposing (..)

type alias Link = {
        url: Url
       ,text: String
       ,pageType: PageType
    }


type LinkText = LinkText String

-- rest api (http gateway) example: http://some-api-host.domain/api
type ApiRootPrefix = ApiRootPrefix String

-- page host (example: "http://some-host.domain/")
type PageRootPrefix = PageRootPrefix String
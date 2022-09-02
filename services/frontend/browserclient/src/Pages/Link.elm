module Pages.Link exposing (..)

import Url exposing (Url)

type alias Link = {
        url: Url
       ,text: String
    }


type LinkText = LinkText String

-- rest api (http gateway) example: http://some-api-host.domain/api
type ApiRootPrefix = ApiRootPrefix String

-- page host (example: "http://some-host.domain/")
type PageRootPrefix = PageRootPrefix String
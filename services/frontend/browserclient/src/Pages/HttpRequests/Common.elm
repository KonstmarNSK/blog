module Pages.HttpRequests.Common exposing (..)

import Http exposing (Error)
import Messages.Messages as Messages exposing (MainPageMessage(..), RequestResult)
import Pages.HttpRequests.Urls as Urls
import Pages.Link as Lnk

-- thing that specifies how to map http response to Message type
type alias RequestMessageMapper = ((Result Http.Error RequestResult) -> Messages.Message)

getCsrfToken: Lnk.ApiRootPrefix -> (String -> RequestResult) -> RequestMessageMapper -> Cmd Messages.Message
getCsrfToken apiUrlPrefix mapper =
        \msgWrapper -> Http.get
            {
                url = (case apiUrlPrefix of
                            Lnk.ApiRootPrefix pref -> pref
                       ) ++ Urls.csrfTokenGetUrl

              , expect = ( Http.expectString (\result -> msgWrapper <| Result.map (\it -> mapper <| it) result) )
            }
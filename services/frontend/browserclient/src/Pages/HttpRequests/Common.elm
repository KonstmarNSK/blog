module Pages.HttpRequests.Common exposing (..)

import Http exposing (Error)
import Messages.Messages as Messages exposing (MainPageMessage(..), RequestResult)
import Pages.HttpRequests.Urls as Urls
import Pages.Link as Lnk


getCsrfToken: Lnk.ApiRootPrefix -> (String -> RequestResult) -> Cmd Messages.Message
getCsrfToken apiUrlPrefix mapper =
        Http.get
            {
                url = (case apiUrlPrefix of
                            Lnk.ApiRootPrefix pref -> pref
                       ) ++ Urls.csrfTokenGetUrl

              , expect = ( Http.expectString
                                <| ( \result ->
                                        Messages.MPMessage
                                        <| GotHttpRequestResult
                                        <| Result.map (\it -> mapper <| it) result
                                    )
                            )
            }
module Pages.ViewPost exposing (..)


import Element exposing (Element, text)
import Messages
import Pages.FromJson.ViewPost as ViewPost
import Pages.PagesModels.ViewPostPageModel exposing (ViewPostPageModel)
import Url exposing (Url)


isSamePage: Url -> Url -> Bool
isSamePage first second = first == second


initModel: ViewPost.ViewPostInitParams -> Result Error ViewPostPageModel
initModel viewPostInitParams =
    Ok ViewPostPageModel


view: ViewPostPageModel -> Element Messages.Message
view viewPostPageModel =
    (text "Me View post page!")


type Error =
    ModelInitError
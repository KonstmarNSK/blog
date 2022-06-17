module Messages exposing (..)


import Http
import Pages.FromJson.MainPage exposing (SubpageInitParams)


type Message =
   MPMessage MainPageMessage

type alias LoadedPageId = String

type MainPageMessage =
    LoadedPageInfo LoadedPageId (Result Http.Error SubpageInitParams)
  | SidebarItemClicked ClickedItemType


type ClickedItemType =
    PageLinkClicked ShowSubpage

type ShowSubpage =
    --LoadedPage String modelType
    NotLoadedPage String String





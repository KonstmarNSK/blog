module Pages.MainPage exposing (..)

import Browser exposing (UrlRequest)
import Element exposing (..)
import Element.Font as Font
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Maybe.Extra
import PageParts.Sidebar exposing (sidebar, SidebarModel, SidebarLink)
import Pages.CreatePost as CP
import Pages.Link as Lnk
import Url exposing (Url)
import Pages.ShowAllPosts as SA
import Pages.ViewPost as VP
import Pages.HomePage as HP


--  TYPES

type MPMessage =
    LinkClicked UrlRequest
  | SubpageLoadedPart SubpageMsg


type SubpageMsg =
    CreatePostPageMsg CP.PageMessage
  | HomepageMsg HP.PageMessage


type SubpageCommonState =
      HomePageState HP.HomePagesState
    | NoSuchPageState
    | CreatePostPageState CP.CommonState
    | ShowAllPostsState SA.CommonState
    | ShowPostState VP.CommonState


type MainPageInitParams =
    MainPageInitParams {
           apiUrlPrefix: String,
           pageUrlPrefix: String
    }


getInitDataFromJson: Decoder MainPageInitParams
getInitDataFromJson =
    Decode.succeed (\ apiUrl pageUrl ->
                        MainPageInitParams {
                            apiUrlPrefix = apiUrl,
                            pageUrlPrefix = pageUrl
                        }
                    )
        |> required "api_root_addr" Decode.string
        |> required "page_root_addr" Decode.string


type MPModel =
    MPModel {
        pagesLinks: List Lnk.Link
       ,apiUrlPrefix: Lnk.ApiRootPrefix
       ,pageUrlPrefix: Lnk.PageRootPrefix
       ,activePage: (AllSubpagesStates -> SubpageCommonState)
       ,allSubpagesStates: AllSubpagesStates
    }

type alias AllSubpagesStates = {
                                   homepageState: HP.HomePagesState
                                  ,createPostPageState: CP.CommonState
                                  ,showAllPostsState: SA.CommonState
                                  ,showPostState: VP.CommonState
                              }

type Error =
    Error




--  FUNCTIONS

errorToString: Error -> String
errorToString error =
    case  error of Error -> "Some unexpected error in MainPage :("




initModel: MainPageInitParams -> Url -> Result Error (MPModel, Cmd MPMessage)
initModel mainPageInitParams url =
    let

        mpParams = case  mainPageInitParams of
                        MainPageInitParams params -> params

        pageUrlPrefix = Lnk.PageRootPrefix mpParams.pageUrlPrefix
        apiUrlPrefix = Lnk.ApiRootPrefix mpParams.apiUrlPrefix

        pagesLinks =
            List.filterMap
                (\maybe -> maybe)
                [
                    CP.getPageLink pageUrlPrefix <| (Lnk.LinkText "Create page"),
                    SA.getPageLink pageUrlPrefix <| (Lnk.LinkText "Show all posts")
                ]

    in
        Ok <| (
                MPModel {
                    pagesLinks = pagesLinks
                    ,apiUrlPrefix = apiUrlPrefix
                    ,pageUrlPrefix = pageUrlPrefix
                    ,activePage = (\states -> HomePageState states.homepageState)
                    ,allSubpagesStates = {
                        homepageState = HP.initState
                       ,createPostPageState = CP.initCommonState
                       ,showAllPostsState = SA.initCommonState
                       ,showPostState = VP.initCommonState
                    }
                },

                Cmd.none
           )


--      UPDATE

update: MPModel -> MPMessage -> (MPMessage -> tMsg) -> (MPModel, Cmd tMsg)
update mainPageModel message msgMapper =
        case message of
            LinkClicked (Browser.Internal href) -> loadPage href mainPageModel msgMapper
            _ -> (mainPageModel, Cmd.none)



loadPage: Url -> MPModel -> (MPMessage -> tMsg) -> (MPModel, Cmd tMsg)
loadPage url mpModel msgMapper =
    let
        mpModelRecord =
            case mpModel of
                MPModel fields -> fields

        allSubpagesStates = mpModelRecord.allSubpagesStates


        cpLoad: Maybe (SubpageCommonState, Cmd tMsg)
        cpLoad =
            Maybe.map
                (\(state, c) -> (CreatePostPageState state, c))
                (CP.loadPage url (\cpMsg -> msgMapper (SubpageLoadedPart (CreatePostPageMsg cpMsg))) allSubpagesStates.createPostPageState)


        hpLoad: Maybe (SubpageCommonState, Cmd tMsg)
        hpLoad =
            Maybe.map
                (\(state, c) -> (HomePageState state, c))
                (HP.loadPage url (\cpMsg -> msgMapper (SubpageLoadedPart (HomepageMsg cpMsg))) allSubpagesStates.homepageState)


        -- todo: rename
        innerLoad: (SubpageCommonState, Cmd tMsg)
        innerLoad =
            case
                Maybe.Extra.orListLazy [
                    \() -> cpLoad,
                    \() -> hpLoad
                ]
            of
                Just (state, c) -> (state, c)
                Nothing -> (NoSuchPageState, Cmd.none)

        (subpageState, cmd) = innerLoad

        newMpState: MPModel
        newMpState =
            case subpageState of
                HomePageState s -> MPModel { mpModelRecord |
                                        activePage = \states -> HomePageState states.homepageState,
                                        allSubpagesStates = { allSubpagesStates |
                                            homepageState = s
                                        }
                                    }

                CreatePostPageState s -> MPModel { mpModelRecord |
                                             activePage = \states -> CreatePostPageState states.createPostPageState,
                                             allSubpagesStates = { allSubpagesStates |
                                                 createPostPageState = s
                                             }
                                         }

                _ -> mpModel

    in
        (newMpState, cmd)

--      VIEW


view: MPModel -> Element MPMessage
view model =
    let
        modelRecord =
            case model of
                MPModel record -> record

        collectSidebarItems =
           List.map (\item -> SidebarLink (Url.toString item.url) item.text) modelRecord.pagesLinks

        sidebarModel =
           SidebarModel collectSidebarItems

        activePage = modelRecord.activePage modelRecord.allSubpagesStates

        drawPage: SubpageCommonState -> Element MPMessage
        drawPage subpageCommonState =
            case subpageCommonState of
                HomePageState s -> HP.view s
                CreatePostPageState s -> CP.view s
                _ -> el [] ( text "No such page!" )


    in
    row [ width <| minimum 600 fill, height fill, Font.size 16 ]
                    [
                        sidebar sidebarModel
                       ,drawPage activePage
                    ]



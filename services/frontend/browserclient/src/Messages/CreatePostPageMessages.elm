module Messages.CreatePostPageMessages exposing (..)


type CreatePostPageMessage =
    RequestResult ReqResult




type ReqResult =
    -- todo: replace Int with type PageVersion
    CsrfTokenReqResult Int String
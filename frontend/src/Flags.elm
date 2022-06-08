module Flags exposing (..)


type alias Flags = {
        createPostComponent : CreatePostComponent,
        getAllPostsComponent : GetAllPostsComponent,
        readSpecificPostComponent : ReadSpecificPostComponent
    }

type alias CreatePostComponent = {
        createPostUrl : String,
        createPostMethod : String
    }

type alias GetAllPostsComponent = {
        getAllPostsUrl : String,
        getAllPostsMethod : String
    }

type alias ReadSpecificPostComponent = {
        postReadUrl : String,
        readPostMethod : String
    }

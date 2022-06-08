package ru.kostya.blog.pages

data class ThePage(
    val createPostComponent: CreatePostComponent,
    val getAllPostsComponent: GetAllPostsComponent,
    val readSpecificPostComponent: ReadSpecificPostComponent,
) {
    companion object {
        const val filePath = "home"
        const val url = ""
    }
}


data class CreatePostComponent(
    val createPostUrl : String = "/api/posts/create-new",
    val createPostMethod: String = "POST"
)

data class GetAllPostsComponent(
    val getAllPostsUrl: String = "/api/posts/get-all",
    val getAllPostsMethod: String = "GET",
)

data class ReadSpecificPostComponent(
    val postReadUrl: String = "/api/posts",
    val readPostMethod: String = "GET",
)

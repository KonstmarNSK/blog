package ru.kostya.blog.pages

data class ThePage(
        val baseUrl: String,
        val createPostPageUrl: String,
        val viewAllPostsPageUrl: String,
) {
    companion object {
        const val filePath = "home"
        const val url = ""
    }
}
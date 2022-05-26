package ru.kostya.blog.pages

data class ShowPostPage(
    val title: String,
    val content: String,
) {
    companion object {
        const val filePath = "post"
        const val url = filePath
    }
}
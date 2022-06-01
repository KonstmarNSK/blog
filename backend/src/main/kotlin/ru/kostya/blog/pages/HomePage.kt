package ru.kostya.blog.pages

import ru.kostya.blog.pages.utils.LinkData

data class HomePage(
    val postsListGetUrl : String,
    val otherPages : List<LinkData> = listOf(
        LinkData(href = CreatePostPage.url, text = "Создать пост"),
        LinkData(href = ListPostPage.url, text = "Посмотреть все посты"),
        LinkData(href = "/swagger", text = "Swagger UI"),
        LinkData(href = "/api-docs", text = "Описание Rest Api в JSON"),
    ),
) {
    companion object {
        const val filePath = "home"
        const val url = ""
    }
}

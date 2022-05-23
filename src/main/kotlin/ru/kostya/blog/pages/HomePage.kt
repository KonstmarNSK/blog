package ru.kostya.blog.pages

import ru.kostya.blog.controllers.utils.LinkData

object HomePage {
    const val filePath = "home"
    const val url = ""

    val otherPages = listOf(
        LinkData(href = CreatePostPage.url, text = "Создать пост"),
        LinkData(href = ListPostPage.url, text = "Посмотреть все посты"),
    )

}

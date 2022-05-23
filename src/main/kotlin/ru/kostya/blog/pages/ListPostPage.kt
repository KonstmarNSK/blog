package ru.kostya.blog.pages

import ru.kostya.blog.controllers.utils.LinkData

data class ListPostPage(val postLinks: List<LinkData>) {
    companion object {
        const val filePath = "list-posts"
        const val url = filePath
    }
}
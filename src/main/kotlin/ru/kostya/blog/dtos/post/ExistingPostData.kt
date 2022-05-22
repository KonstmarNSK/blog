package ru.kostya.blog.dtos.post

data class ExistingPostData(
    val postId: PostId,
    val title: String,
    val content: String,
)

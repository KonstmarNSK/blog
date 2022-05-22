package ru.kostya.blog.mappings

import ru.kostya.blog.dtos.post.ExistingPostData
import ru.kostya.blog.dtos.post.PostCreationInput
import ru.kostya.blog.dtos.post.PostCreationOutput
import ru.kostya.blog.dtos.post.PostId
import ru.kostya.blog.entities.Post
import java.lang.IllegalStateException

fun Post.toCreationOutputDto(): PostCreationOutput =
    PostCreationOutput(
        postId = PostId(this.id ?: throw IllegalStateException("Requested post has no ID..."))
    )

fun PostCreationInput.toPostDbEntity() : Post =
    Post(
        id = null,
        title = this.title,
        content = this.content
    )

fun Post.toExistingPostDto() : ExistingPostData =
    ExistingPostData(
        postId = PostId(this.id ?: throw IllegalStateException("One of existing posts has no ID...")),
        title = this.title ?: "<NO title>",
        content = this.content ?: "<NO content>"
    )
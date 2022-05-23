package ru.kostya.blog.operations.post

import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import ru.kostya.blog.operations.post.common.PostId
import ru.kostya.blog.mappings.toExistingPostDto
import ru.kostya.blog.repositories.PostRepository
import ru.kostya.blog.operations.NoInputOperation
import ru.kostya.blog.operations.post.ReadAllPostsOperation.ExistingPostData

@Component
class ReadAllPostsOperation(private val postRepo: PostRepository) : NoInputOperation<List<ExistingPostData>> {
    data class ExistingPostData(val postId: PostId, val title: String, val content: String)

    @Transactional(readOnly = true)
    override fun process(): List<ExistingPostData> =
        postRepo.findAll().map { it.toExistingPostDto() }
}
package ru.kostya.blog.operations.post

import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import ru.kostya.blog.operations.post.common.PostId
import ru.kostya.blog.mappings.toCreationOutputDto
import ru.kostya.blog.mappings.toPostDbEntity
import ru.kostya.blog.repositories.PostRepository
import ru.kostya.blog.operations.Operation
import ru.kostya.blog.operations.post.PostCreationOperation.PostCreationInput
import ru.kostya.blog.operations.post.PostCreationOperation.PostCreationOutput

@Component
class PostCreationOperation(private val postRepo: PostRepository) : Operation<PostCreationInput, PostCreationOutput> {
    data class PostCreationInput (val title: String, val content: String)
    data class PostCreationOutput (val postId: PostId)

    @Transactional
    override fun process(input: PostCreationInput): PostCreationOutput =
        postRepo.save(input.toPostDbEntity()).toCreationOutputDto()
}
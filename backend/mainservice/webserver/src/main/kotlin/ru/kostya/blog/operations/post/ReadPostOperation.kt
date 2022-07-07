package ru.kostya.blog.operations.post

import org.springframework.stereotype.Component
import ru.kostya.blog.mappings.toExistingPostDto
import ru.kostya.blog.operations.Operation
import ru.kostya.blog.operations.post.ReadAllPostsOperation.ExistingPostData
import ru.kostya.blog.operations.post.common.PostId
import ru.kostya.blog.repositories.PostRepository

@Component
class ReadPostOperation(private val postRepository: PostRepository) : Operation<PostId, ExistingPostData?> {
    override fun process(input: PostId): ExistingPostData? =
        postRepository.findById(input.id).orElse(null)?.toExistingPostDto()
}
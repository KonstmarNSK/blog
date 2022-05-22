package ru.kostya.blog.services

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import ru.kostya.blog.dtos.post.ExistingPostData
import ru.kostya.blog.dtos.post.PostCreationInput
import ru.kostya.blog.dtos.post.PostCreationOutput
import ru.kostya.blog.dtos.post.PostId
import ru.kostya.blog.mappings.toExistingPostDto
import ru.kostya.blog.mappings.toPostDbEntity
import ru.kostya.blog.repositories.PostRepository
import java.lang.IllegalStateException

@Service
class PostService(
    val postRepository: PostRepository
) {

    @Transactional
    fun createNewPost(newPostData: PostCreationInput) : PostCreationOutput {
        val dbEntity = newPostData.toPostDbEntity()

        val saved = postRepository.save(dbEntity)

        return PostCreationOutput(
            PostId(saved.id ?: throw IllegalStateException("DB id wasn't assigned to created post"))
        )
    }

    @Transactional(readOnly = true)
    fun getAllPosts() : List<ExistingPostData> = postRepository.findAll().map { it.toExistingPostDto() }
}
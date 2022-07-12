package ru.kostya.blog.rest

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseBody
import ru.kostya.blog.operations.post.PostCreationOperation
import ru.kostya.blog.operations.post.PostCreationOperation.PostCreationInput
import ru.kostya.blog.operations.post.PostCreationOperation.PostCreationOutput
import ru.kostya.blog.operations.post.ReadAllPostsOperation
import ru.kostya.blog.operations.post.ReadAllPostsOperation.ExistingPostData
import ru.kostya.blog.operations.post.ReadPostOperation
import ru.kostya.blog.operations.post.common.PostId

@Controller
@RequestMapping("/api/posts")
class PostController(
    private val readPostOperation: ReadPostOperation,
    private val readAllPostsOperation: ReadAllPostsOperation,
    private val postCreationOperation: PostCreationOperation,
) {

    @GetMapping("/get-all")
    @ResponseBody
    fun getAllPosts() : List<ExistingPostData> = readAllPostsOperation.process()

    @GetMapping("/{postId}")
    @ResponseBody
    fun getPost(@PathVariable postId: PostId) : ExistingPostData =
        // fixme: process nonexistent postId correctly (show 404)
        readPostOperation.process(postId) ?: throw IllegalArgumentException("Not-existing post id: $postId")

    @PostMapping("/create-new")
    @ResponseBody
    fun createNewPost(newPostData: PostCreationInput) : PostCreationOutput =
        postCreationOperation.process(newPostData)
}
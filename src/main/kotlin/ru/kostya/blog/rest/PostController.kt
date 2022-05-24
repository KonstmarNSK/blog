package ru.kostya.blog.rest

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import ru.kostya.blog.operations.post.PostCreationOperation
import ru.kostya.blog.operations.post.PostCreationOperation.PostCreationInput
import ru.kostya.blog.operations.post.PostCreationOperation.PostCreationOutput
import ru.kostya.blog.operations.post.ReadAllPostsOperation
import ru.kostya.blog.operations.post.ReadAllPostsOperation.ExistingPostData

@Controller
@RequestMapping("/post")
class PostController(
    private val readAllPostsOperation: ReadAllPostsOperation,
    private val postCreationOperation: PostCreationOperation,
) {

    @GetMapping("/get-all")
    @ResponseBody
    fun getAllPosts() : List<ExistingPostData> = readAllPostsOperation.process()

    @PostMapping("/create-new")
    @ResponseBody
    fun createNewPost(@RequestBody newPostData: PostCreationInput) : PostCreationOutput =
        postCreationOperation.process(newPostData)
}
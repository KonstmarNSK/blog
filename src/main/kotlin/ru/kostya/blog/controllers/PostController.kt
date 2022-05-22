package ru.kostya.blog.controllers

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseBody
import ru.kostya.blog.dtos.post.ExistingPostData
import ru.kostya.blog.dtos.post.PostCreationInput
import ru.kostya.blog.dtos.post.PostCreationOutput
import ru.kostya.blog.services.PostService

@Controller
@RequestMapping("/post")
class PostController(
    private val postService: PostService
) {

    @GetMapping("/get-all")
    @ResponseBody
    fun getAllPosts() : List<ExistingPostData> = postService.getAllPosts()

    @PostMapping("/create-new")
    @ResponseBody
    fun createNewPost(@RequestBody newPostData: PostCreationInput) : PostCreationOutput =
        postService.createNewPost(newPostData)
}
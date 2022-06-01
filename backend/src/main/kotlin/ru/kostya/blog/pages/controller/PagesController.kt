package ru.kostya.blog.pages.controller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import ru.kostya.blog.operations.post.ReadAllPostsOperation
import ru.kostya.blog.operations.post.ReadPostOperation
import ru.kostya.blog.operations.post.common.PostId
import ru.kostya.blog.pages.CreatePostPage
import ru.kostya.blog.pages.HomePage
import ru.kostya.blog.pages.ListPostPage
import ru.kostya.blog.pages.ShowPostPage
import ru.kostya.blog.pages.utils.LinkData

@Controller
class PagesController(
    private val readAllPostsOperation: ReadAllPostsOperation,
    private val readPostOperation: ReadPostOperation,
) {
    companion object {
        const val PAGE_ATTR_NAME = "page"
    }


    @GetMapping(HomePage.url)
    fun homePage(model: Model): String {
        model.addAttribute(PAGE_ATTR_NAME, HomePage(postsListGetUrl = "/get-all"))
        return HomePage.filePath
    }

    @GetMapping(CreatePostPage.url)
    fun createPostPage(model: Model): String {
        model.addAttribute(PAGE_ATTR_NAME, CreatePostPage)
        return CreatePostPage.filePath
    }

    @GetMapping(ListPostPage.url)
    fun listPostPage(model: Model): String {
        val postsLinks = readAllPostsOperation.process()
            .map { LinkData("${ShowPostPage.url}/${it.postId.id}", it.title) }

        model.addAttribute(PAGE_ATTR_NAME, ListPostPage(postsLinks))
        return ListPostPage.filePath
    }

    @GetMapping("${ShowPostPage.url}/{post_id}")
    fun showPostPage(@PathVariable("post_id") postId: PostId, model: Model): String {
        // todo: process exceptions correctly (show 404 page)
        val foundPost = readPostOperation.process(postId) ?: throw java.util.NoSuchElementException("No post with id $postId exists")

        model.addAttribute(PAGE_ATTR_NAME, ShowPostPage(foundPost.title, foundPost.content))
        return ShowPostPage.filePath
    }
}
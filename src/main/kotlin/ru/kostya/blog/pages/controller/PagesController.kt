package ru.kostya.blog.pages.controller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import ru.kostya.blog.pages.CreatePostPage
import ru.kostya.blog.pages.HomePage
import ru.kostya.blog.pages.ListPostPage
import ru.kostya.blog.pages.ShowPostPage

@Controller
class PagesController {
    companion object{
        const val PAGE_ATTR_NAME = "page"
    }


    @GetMapping(HomePage.url)
    fun homePage(model : Model): String {
        model.addAttribute(PAGE_ATTR_NAME, HomePage)
        return HomePage.filePath
    }

    @GetMapping(CreatePostPage.url)
    fun createPostPage(model : Model) : String{
        model.addAttribute(PAGE_ATTR_NAME, CreatePostPage)
        return CreatePostPage.filePath
    }

    @GetMapping(ListPostPage.url)
    fun listPostPage(model : Model): String {
        model.addAttribute(PAGE_ATTR_NAME, ListPostPage)
        return ListPostPage.filePath
    }

    @GetMapping(ShowPostPage.url)
    fun showPostPage(model : Model) : String{
        model.addAttribute(PAGE_ATTR_NAME, ShowPostPage)
        return ShowPostPage.filePath
    }
}
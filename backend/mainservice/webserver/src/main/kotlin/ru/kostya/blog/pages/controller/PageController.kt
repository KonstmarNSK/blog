package ru.kostya.blog.pages.controller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import ru.kostya.blog.pages.ThePage

@Controller
class PageController {
    companion object {
        const val PAGE_ATTR_NAME = "page"
    }


    @GetMapping(ThePage.url)
    fun homePage(model: Model): String {
        val page = ThePage(
            baseUrl = ""
           ,createPostPageUrl = ""
           ,viewAllPostsPageUrl = ""
        )

        model.addAttribute(PAGE_ATTR_NAME, page)
        return ThePage.filePath
    }
}
package ru.kostya.blog.controllers

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseBody
import ru.kostya.blog.configs.properties.SecurityProperties
import ru.kostya.blog.pages.HomePage

@Controller
@RequestMapping("/")
class HomeController(
    val secProps: SecurityProperties
) {
    @GetMapping(HomePage.url)
    fun returnHomepage(model : Model): String {
        model.addAttribute("page", HomePage)

        return HomePage.filePath
    }

    @ResponseBody
    @GetMapping("/security")
    fun returnSecEnabled(): Boolean = secProps.enabled
}
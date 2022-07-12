package ru.kostya.blog.rest

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseBody
import ru.kostya.blog.configs.properties.SecurityProperties

@Controller
@RequestMapping("/")
class HomeController(
    val secProps: SecurityProperties
) {
    @ResponseBody
    @GetMapping("/security")
    fun returnSecEnabled(): Boolean = secProps.enabled
}
package ru.kostya.blog.configs

import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.WebSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer
import ru.kostya.blog.configs.properties.SecurityProperties


@Configuration
@EnableWebSecurity
class SecurityConfiguration(val secProps: SecurityProperties) : WebSecurityCustomizer {

    override fun customize(web: WebSecurity?) {
        if(!secProps.enabled) {
            web?.ignoring()?.anyRequest()
        }
    }
}
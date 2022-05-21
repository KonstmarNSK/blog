package ru.kostya.blog.configs.properties

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.context.properties.ConstructorBinding

@ConfigurationProperties(prefix = "blog.security")
@ConstructorBinding
class SecurityProperties (
    val enabled: Boolean
)
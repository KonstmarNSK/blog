package ru.kostya.blog.operations.post.common

import org.springframework.core.convert.converter.Converter
import org.springframework.stereotype.Component

data class PostId(val id: Long)

@Component
class StringToPostIdConverter : Converter<String, PostId> {
    override fun convert(source: String): PostId? = PostId(source.toLong())
}
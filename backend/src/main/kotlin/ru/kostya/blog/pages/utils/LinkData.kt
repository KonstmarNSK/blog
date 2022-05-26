package ru.kostya.blog.pages.utils

// text - текст ссылки, href - url, на который ссылаемся
// (например, для ссылки http://some-host/context-path/path href будет "/path")
data class LinkData(val href: String, val text: String)
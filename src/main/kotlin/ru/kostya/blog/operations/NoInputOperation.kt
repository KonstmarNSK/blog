package ru.kostya.blog.operations

interface NoInputOperation<TOutput>{
    fun process(): TOutput
}
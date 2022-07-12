package ru.kostya.blog.operations

interface NoOutputOperation<TInput>{
    fun process(input: TInput)
}
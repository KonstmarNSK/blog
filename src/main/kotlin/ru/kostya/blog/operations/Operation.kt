package ru.kostya.blog.operations

interface Operation<TInput, TOutput> {
    fun process(input: TInput) : TOutput
}
package com.kostya.blog.utils


inline fun <TInput, TOutput> Collection<TInput>.tryMap(mapper: (TInput) -> Result<TOutput>): Result<Collection<TOutput>> {
    val newColl = mutableListOf<TOutput>()

    for (item in this){
        when(val result = mapper.invoke(item)){ // todo: runCatching
            Result<TOutput>::isSuccess -> newColl.add(result.getOrThrow())  // must never throw
            Result<TOutput>::isFailure -> return Result.failure(result.exceptionOrNull()!!) // always not-null because it's failure
        }
    }

    return Result.success(newColl)
}
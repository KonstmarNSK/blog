package ru.kostya.blog.repositories

import org.springframework.data.repository.CrudRepository
import ru.kostya.blog.entities.Post

interface PostRepository : CrudRepository<Post, Long>
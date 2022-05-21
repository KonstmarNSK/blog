package ru.kostya.blog.entities

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table


@Entity
@Table(name = "post", schema = "blog")
class Post (
    @Id
    val id: Long,

    @Column(name = "title")
    val title: String,

    @Column(name="content")
    val content: String,
)
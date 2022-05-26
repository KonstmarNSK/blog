package ru.kostya.blog.entities

import javax.persistence.*


@Entity
@Table(name = Post.POST_TABLE_NAME, schema = BLOG_SCHEMA_NAME)
class Post (
    @Id
    @GeneratedValue(generator = "post-id-seq-generator")
    @SequenceGenerator(
        name="post-id-seq-generator",
        sequenceName = "post_id_sequence",
        schema = BLOG_SCHEMA_NAME,
        allocationSize=25
    )
    val id: Long?,

    @Column(name = "title")
    val title: String?,

    @Column(name="content")
    val content: String?,
){


    companion object{
        const val POST_TABLE_NAME = "post"
    }
}
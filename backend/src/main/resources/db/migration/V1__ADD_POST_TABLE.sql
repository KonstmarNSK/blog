create table if not exists blog.post (
    id bigint not null,
    title varchar(100) not null,
    content varchar(5000)
);

create sequence if not exists blog.post_id_sequence increment by 25 minvalue 1 start with 1 no cycle owned by post.id;

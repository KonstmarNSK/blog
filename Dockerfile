FROM adoptopenjdk/openjdk11

ADD ./build/libs/executable-blog-*.jar /app/blog.jar

CMD java -jar /app/blog.jar

EXPOSE 8082
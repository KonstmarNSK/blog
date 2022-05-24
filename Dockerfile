FROM adoptopenjdk/openjdk11

ARG DEBUG_BUILD=false
ARG DEBUG_PORT=9053

ENV DEBUG_BUILD=$DEBUG_BUILD
ENV DEBUG_PORT=$DEBUG_PORT

ADD ./build/libs/executable-blog-*.jar /app/blog.jar
ADD ./docker-run.sh /app/docker-run.sh

CMD bash /app/docker-run.sh

EXPOSE 8082
EXPOSE 9053
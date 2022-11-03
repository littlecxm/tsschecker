FROM alpine:edge

WORKDIR /app
COPY build-docker.sh /app
RUN ["chmod", "+x", "/app/build-docker.sh"]
RUN /app/build-docker.sh
RUN rm /app/build-docker.sh
RUN tsschecker --help

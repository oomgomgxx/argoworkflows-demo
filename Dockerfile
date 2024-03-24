# syntax = docker/dockerfile:experimental
FROM gradle:jdk21-alpine as app-builder
WORKDIR /app
COPY . .
# Dockerfile 在构建期间默认使用 root 权限
# --mount=type=cache,target=/root/.gradle 将本地主机上的缓存目录挂载到容器内的 /root/.gradle 目录中
# 使用 --no-daemon 参数禁用 Gradle 守护进程模式，减小内存消耗
RUN --mount=type=cache,target=/root/.gradle gradle --no-daemon clean bootJar -x test

# 自定义运行时，可以大大减少镜像大小
FROM gradle:jdk21-alpine as jre-build
RUN $JAVA_HOME/bin/jlink \
--add-modules jdk.unsupported,java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
--strip-debug \
--no-man-pages \
--no-header-files \
--compress=zip-6 \
--output /javaruntime

#FROM ubuntu:jammy
#FROM debian:stretch-slim
FROM alpine:latest
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME
WORKDIR /app
COPY --from=app-builder /app/build/libs/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

#FROM eclipse-temurin:21.0.2_13-jre-alpine
#WORKDIR /app
#COPY --from=app-builder /app/build/libs/*.jar /app/app.jar
#EXPOSE 8080
#ENTRYPOINT ["java", "-jar", "app.jar"]

# docker build -t gradle-demo .
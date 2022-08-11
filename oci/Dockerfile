FROM amazoncorretto:11-alpine-jdk

ADD ..\app\target\cloud-infra-demo*.jar \app.jar

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "/app.jar" ]
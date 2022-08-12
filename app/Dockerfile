FROM amazoncorretto:11-alpine-jdk as BUILD

COPY ./src /app/src
# I realize this is bad form. I got a little tired of fighting with mvnw and just 
# decided to copy the .mvn directory into the context whole.
COPY ./.mvn /app/.mvn
COPY ./mvnw /app/mvnw
COPY ./pom.xml /app/pom.xml

RUN \
    chmod +x /app/mvnw && \
    cd app && \
    ./mvnw package && \
    true


FROM amazoncorretto:11-alpine-jdk

COPY --from=BUILD /app/target/*.jar /app.jar

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "app.jar" ]
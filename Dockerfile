FROM maven:3-openjdk-11 as build
WORKDIR /wowchat-mqtt

COPY pom.xml .

RUN mvn verify clean --fail-never

COPY . .

RUN mvn package

FROM openjdk:11-slim as final

ARG WOW_ACCOUNT
ENV WOW_ACCOUNT=${WOW_ACCOUNT}

ARG WOW_PASSWORD
ENV WOW_PASSWORD=${WOW_PASSWORD}

ARG WOW_CHARACTER
ENV WOW_CHARACTER=${WOW_CHARACTER}

ARG DISCORD_TOKEN
ENV DISCORD_TOKEN=${DISCORD_TOKEN}

COPY --from=build /wowchat-mqtt/target/wowchat-mqtt.jar /usr/local/lib/wowchat-mqtt.jar
COPY --from=build /wowchat-mqtt/src/main/resources/logback.xml /usr/local/lib/wowchat-mqtt/logback.xml
COPY --from=build /wowchat-mqtt/src/main/resources/wowchat.conf /usr/local/lib/wowchat-mqtt/wowchat.conf


ENTRYPOINT ["java", "-XX:+HeapDumpOnOutOfMemoryError", "-Dfile.encoding=UTF-8", "-Dlogback.configurationFile=/usr/local/lib/wowchat-mqtt/logback.xml", "-jar", "/usr/local/lib/wowchat-mqtt.jar", "/usr/local/lib/wowchat-mqtt/wowchat.conf"]
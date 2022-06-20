# TIP - use SHA with non-semantic versions
#   dependabot expects dot-delimited version numbers (for example, https://semver.org/)
#   Node has a concept of long-term support releases. However, you don't want a tag that can update outside of a code change.
#   In these cases, you can use a generic tag (lts) and pin it to a specific SHA, and dependabot will update that instead.
FROM node:lts@sha256:2d085d25d573a58266319362f32e978f94e06214a62fae15c02d4c4f0567b64f as build-node

WORKDIR /app/client

# cache dependencies
COPY example-app/client/package.json example-app/client/yarn.lock ./
RUN yarn install

# build
COPY example-app/client ./
RUN yarn build

FROM openjdk:17.0.2 as build-java

WORKDIR /app/resourceserver/src

# cache dependencies
COPY example-app/resourceserver/build.gradle.kts example-app/resourceserver/settings.gradle.kts example-app/resourceserver/gradlew ./
COPY example-app/resourceserver/gradle/ ./gradle
# ignore failure due to lack of source code
RUN chmod +x gradlew && ./gradlew --no-daemon build || true

# build
COPY example-app/resourceserver ./
RUN chmod +x gradlew && ./gradlew --no-daemon build
RUN mkdir -p /app/resourceserver/build && \
  cp -r /app/resourceserver/src/build/libs /app/resourceserver/build && \
  mv /app/resourceserver/build/libs/resourceserver*.jar /app/resourceserver/build/resourceserver.jar

FROM scratch as build-aggregation
COPY --from=build-java /app/resourceserver/build /app
COPY --from=build-node /app/client/build /app/static

FROM scratch as windows-export
COPY --from=build-aggregation /app /
COPY server/run.bat /

FROM openjdk:17.0.2
COPY --from=build-aggregation /app /app
ENTRYPOINT ["java", "-Dlogging.level.org.springframework.web=DEBUG", "-Dspring.resources.static-locations=file:/app/static/", "-jar", "/app/resourceserver.jar"]

# Stage 1: Build the Jenkins plugin using Maven and Java 11
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy source code
COPY . .

# Ensure required jelly file exists to prevent build failure
RUN mkdir -p src/main/resources && \
    echo "<?jelly escape-by-default='true'?><div>Hello from my Jenkins plugin!</div>" > src/main/resources/index.jelly

# Build plugin
RUN mvn clean install -DskipTests

# Stage 2: Minimal image to hold the plugin artifact
FROM eclipse-temurin:11-jre

WORKDIR /plugin

# Copy built plugin
COPY --from=builder /app/target/*.hpi ./my-jenkins-plugin.hpi

CMD ["echo", "Build complete. .hpi file is ready in /plugin"]

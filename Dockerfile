# Stage 1: Build the plugin
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy source code
COPY . .

# Ensure index.jelly exists to satisfy maven-hpi-plugin
RUN mkdir -p src/main/resources && \
    echo "<?jelly escape-by-default='true'?>\n<div>Default plugin view</div>" > src/main/resources/index.jelly

# Build the plugin
RUN mvn clean install -DskipTests

# Stage 2: Runtime container (optional if you're just building the plugin)
FROM eclipse-temurin:11-jre

WORKDIR /plugin

# Copy built plugin .hpi file from the builder stage
COPY --from=builder /app/target/*.hpi ./my-jenkins-plugin.hpi

# Optional: CMD to keep container alive or copy somewhere else
CMD ["ls", "-l", "/plugin"]

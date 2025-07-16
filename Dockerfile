# Use official Maven image with JDK 11
FROM maven:3.9.6-eclipse-temurin-11 AS builder

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Build Jenkins plugin (skip tests for faster builds)
RUN mvn clean install -DskipTests

# Final lightweight image to store the .hpi plugin
FROM eclipse-temurin:11-jre

# Set working directory in final image
WORKDIR /jenkins-plugin

# Copy only the final .hpi artifact
COPY --from=builder /app/target/*.hpi ./my-jenkins-plugin.hpi

# Optional: Entry point (not necessary unless running something)
CMD ["echo", "Jenkins Plugin build complete. Use this .hpi file in Jenkins."]

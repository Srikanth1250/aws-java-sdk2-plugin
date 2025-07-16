# Base image with Java and Maven
FROM maven:3.9.6-eclipse-temurin-11 AS builder

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Build the plugin
RUN mvn clean install -DskipTests

# -------------------------------------------
# Runtime image to run Jenkins with the plugin
# -------------------------------------------
FROM jenkins/jenkins:lts-jdk11

# Skip setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Create plugins directory if not exists
RUN mkdir -p /usr/share/jenkins/ref/plugins

# Copy the HPI plugin built from previous stage
COPY --from=builder /app/target/*.hpi /usr/share/jenkins/ref/plugins/

# Expose Jenkins default port
EXPOSE 8080

# Default command
CMD ["jenkins"]

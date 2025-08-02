# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY mvnw .
# Add execute permissions to the Maven wrapper script
RUN chmod +x mvnw
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Build the project using the Maven Wrapper
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the final image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the built JAR with the new name from the build stage
COPY --from=build /app/target/tech-circulo-docker.jar tech-circulo-docker.jar

# Expose the application port
EXPOSE 8084

# Run the application
ENTRYPOINT ["java", "-jar", "tech-circulo-docker.jar"]

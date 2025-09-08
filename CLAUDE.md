# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ktor-based web application using Kotlin. The project uses Gradle with Version Catalog for dependency management.

## Common Commands

### Build & Run
- `./gradlew run` - Run the server (starts on port 8080)
- `./gradlew build` - Build the project
- `./gradlew clean build` - Clean and rebuild
- `./gradlew test` - Run tests (currently no tests exist)

### Ktor-specific Tasks
- `./gradlew buildFatJar` - Build executable JAR with all dependencies
- `./gradlew runFatJar` - Build and run the fat JAR
- `./gradlew buildImage` - Build Docker image
- `./gradlew runDocker` - Run using Docker

## Architecture

### Core Structure
- **Application Entry**: `src/main/kotlin/Application.kt` - Contains main() and module configuration
- **Routing**: `src/main/kotlin/Routing.kt` - HTTP route definitions
- **Configuration**: `src/main/resources/application.yaml` - Server configuration (port 8080)
- **Package**: `com.kinto.dx`

### Dependency Management
The project uses Gradle Version Catalog:
- `gradle/libs.versions.toml` - Central version and dependency definitions
- Dependencies are referenced using `libs.` notation in `build.gradle.kts`

### Key Technologies
- **Ktor 3.2.3**: Async web framework
- **Kotlin 2.1.10**: Programming language
- **Netty**: Server engine
- **Logback**: Logging framework
- **YAML**: Configuration format

### Module System
Ktor uses a modular plugin system. The application is configured through extension functions:
- `Application.module()` - Main module configuration
- `Application.configureRouting()` - Route configuration

The server starts with Netty engine and loads modules defined in `application.yaml`.
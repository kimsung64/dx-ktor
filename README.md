# DX-Ktor

A web application project based on Ktor framework. Built with Kotlin and Ktor, utilizing MySQL and Redis as data stores.

## Project Structure

```
dx-ktor/
├── src/
│   └── main/
│       ├── kotlin/
│       │   └── com/kinto/dx/
│       │       ├── Application.kt    # Application entry point
│       │       └── Routing.kt         # Route configuration
│       └── resources/
│           └── application.yaml       # Server configuration
├── gradle/
│   └── libs.versions.toml            # Version Catalog (dependency management)
├── build.gradle.kts                  # Build configuration
├── settings.gradle.kts                # Project settings
├── docker-compose.yml                 # Docker container configuration
├── Makefile                          # Build and run automation
├── .env                              # Environment variables (git ignored)
└── .env.example                      # Environment variables example

```

## Technology Stack

### Core Technologies
- **Kotlin** 2.1.10 - Programming language
- **Ktor** 3.2.3 - Asynchronous web framework
- **Gradle** 8.14.3 - Build tool (with Version Catalog)

### Main Libraries
- **Netty** - Server engine
- **Logback** 1.4.14 - Logging
- **YAML** - Configuration file format

### Infrastructure
- **MySQL** 8.0 - Relational database
- **Redis** 7 - In-memory data store
- **Docker** - Containerization

## Getting Started

### Prerequisites
- JDK 17 or higher
- Docker and Docker Compose
- Make (optional, for Makefile usage)

### Quick Start

1. **Setup Environment**
   ```bash
   # Copy from example if .env doesn't exist
   cp .env.example .env
   # Edit .env file to update passwords if needed
   ```

2. **Start Docker Containers**
   ```bash
   make up
   # or docker-compose up -d
   ```

3. **Run Application**
   ```bash
   make run
   # or ./gradlew run
   ```

4. **Verify Access**
   ```
   http://localhost:8080/
   ```

## Makefile Usage

### Docker Management
| Command | Description |
|---------|-------------|
| `make up` | Start all containers in background |
| `make down` | Stop and remove all containers |
| `make restart` | Restart all containers |
| `make logs` | Show logs from all containers |
| `make logs-mysql` | Show MySQL logs only |
| `make logs-redis` | Show Redis logs only |
| `make ps` | Show container status |
| `make clean` | Stop containers and remove volumes (⚠️ Deletes data) |

### Database Access
| Command | Description |
|---------|-------------|
| `make mysql-shell` | Connect to MySQL shell (regular user) |
| `make mysql-root` | Connect to MySQL shell (root) |
| `make redis-cli` | Connect to Redis CLI |

### Application Build/Run
| Command | Description |
|---------|-------------|
| `make build` | Build application |
| `make run` | Run application |
| `make test` | Run tests |
| `make clean-build` | Clean build |

### Utilities
| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make setup` | Initial setup (create env file and start containers) |
| `make check-ports` | Check port availability |

## Gradle Tasks

### Main Gradle Commands
```bash
./gradlew run              # Run application
./gradlew build            # Build project
./gradlew test             # Run tests
./gradlew clean            # Clean build directory
./gradlew buildFatJar      # Build executable JAR
./gradlew runFatJar        # Build and run Fat JAR
./gradlew buildImage       # Build Docker image
./gradlew runDocker        # Run with Docker
```

## Port Configuration

| Service | Port | Description |
|---------|------|-------------|
| Ktor | 8080 | HTTP server |
| MySQL | 3307 | Database (host) |
| Redis | 6380 | Cache server (host) |

> Note: MySQL and Redis use alternative ports instead of defaults. 
> You can modify `MYSQL_PORT` and `REDIS_PORT` in `.env` file if needed.

## Environment Variables

Configure the following environment variables in `.env` file:

```bash
# MySQL Configuration
MYSQL_ROOT_PASSWORD=rootpassword123
MYSQL_DATABASE=dx_ktor
MYSQL_USER=ktor_user
MYSQL_PASSWORD=ktor_password123
MYSQL_PORT=3307

# Redis Configuration
REDIS_PORT=6380

# Application Connection URLs
DATABASE_URL=jdbc:mysql://localhost:3307/dx_ktor
REDIS_URL=redis://localhost:6380
```

## Troubleshooting

### Port Conflicts
If default ports are already in use:
1. Check port usage with `make check-ports`
2. Modify `MYSQL_PORT` or `REDIS_PORT` in `.env` file
3. Restart containers with `make restart`

### Reset Docker Containers
```bash
make clean  # Remove all containers and data
make up     # Start fresh
```

## Development Guide

### Adding New Routes
Add routes in `src/main/kotlin/com/kinto/dx/Routing.kt`:

```kotlin
fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("Hello World!")
        }
        // Add new route
        get("/api/health") {
            call.respondText("OK")
        }
    }
}
```

### Adding Dependencies
Manage dependencies through Version Catalog in `gradle/libs.versions.toml`:

```toml
[versions]
newlibrary = "1.0.0"

[libraries]
newlibrary = { module = "group:artifact", version.ref = "newlibrary" }
```

## References

- [Ktor Documentation](https://ktor.io/docs/home.html)
- [Kotlin Documentation](https://kotlinlang.org/docs/home.html)
- [Gradle Version Catalog](https://docs.gradle.org/current/userguide/platforms.html)

## License

This project is under the MIT License.
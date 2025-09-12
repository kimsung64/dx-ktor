.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m\033[0m"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Docker Commands

.PHONY: up
up: ## Start all containers in background
	docker-compose up -d

.PHONY: down
down: ## Stop and remove all containers
	docker-compose down

.PHONY: restart
restart: down up ## Restart all containers

.PHONY: logs
logs: ## Show logs from all containers
	docker-compose logs -f

.PHONY: logs-mysql
logs-mysql: ## Show MySQL container logs
	docker-compose logs -f mysql

.PHONY: logs-redis
logs-redis: ## Show Redis container logs
	docker-compose logs -f redis

.PHONY: ps
ps: ## Show container status
	docker-compose ps

.PHONY: clean
clean: ## Stop containers and remove volumes (WARNING: Deletes all data!)
	docker-compose down -v

##@ Database Commands

.PHONY: mysql-shell
mysql-shell: ## Connect to MySQL shell
	docker exec -it dx-ktor-mysql mysql -u${MYSQL_USER:-ktor_user} -p${MYSQL_PASSWORD:-ktor_password123} ${MYSQL_DATABASE:-dx_ktor}

.PHONY: mysql-root
mysql-root: ## Connect to MySQL as root
	docker exec -it dx-ktor-mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD:-rootpassword123}

.PHONY: redis-cli
redis-cli: ## Connect to Redis CLI
	docker exec -it dx-ktor-redis redis-cli

##@ Application Commands

.PHONY: build
build: ## Build the application
	./gradlew build

.PHONY: run
run: ## Run the application (local environment)
	KTOR_ENV=local ./gradlew run

.PHONY: run-local
run-local: ## Run with local environment
	KTOR_ENV=local ./gradlew run

.PHONY: run-dev
run-dev: ## Run with dev environment
	KTOR_ENV=dev ./gradlew run

.PHONY: run-stg
run-stg: ## Run with staging environment
	KTOR_ENV=stg ./gradlew run

.PHONY: run-prod
run-prod: ## Run with production environment (use with caution!)
	@echo "⚠️  WARNING: Running with production configuration!"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	KTOR_ENV=prod ./gradlew run

.PHONY: test
test: ## Run tests
	./gradlew test

.PHONY: clean-build
clean-build: ## Clean and build the application
	./gradlew clean build

##@ Setup Commands

.PHONY: setup
setup: ## Initial setup: copy .env.example and start containers
	@if [ ! -f .env ]; then \
		echo "Creating .env file from .env.example..."; \
		cp .env.example .env; \
		echo "Please update .env with your desired passwords"; \
	fi
	@echo "Starting Docker containers..."
	@make up
	@echo "Waiting for services to be healthy..."
	@sleep 5
	@make ps

.PHONY: check-ports
check-ports: ## Check if required ports are available
	@echo "Checking port availability..."
	@lsof -i :${MYSQL_PORT:-3307} > /dev/null 2>&1 && echo "⚠️  Port ${MYSQL_PORT:-3307} (MySQL) is already in use" || echo "✅ Port ${MYSQL_PORT:-3307} (MySQL) is available"
	@lsof -i :${REDIS_PORT:-6380} > /dev/null 2>&1 && echo "⚠️  Port ${REDIS_PORT:-6380} (Redis) is already in use" || echo "✅ Port ${REDIS_PORT:-6380} (Redis) is available"
	@lsof -i :8080 > /dev/null 2>&1 && echo "⚠️  Port 8080 (Ktor) is already in use" || echo "✅ Port 8080 (Ktor) is available"
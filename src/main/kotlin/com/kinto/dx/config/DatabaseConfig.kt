package com.kinto.dx.config

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import io.ktor.server.application.Application
import io.ktor.server.config.ApplicationConfig
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction
import org.slf4j.LoggerFactory

object DatabaseConfig {
    private val logger = LoggerFactory.getLogger(this::class.java)
    
    fun Application.configureDatabases() {
        val config = environment.config
        val env = System.getenv("KTOR_ENV") ?: "local"
        
        logger.info("Initializing database for environment: $env")
        
        try {
            val dbConfig = config.config("database")
            val dataSource = createHikariDataSource(dbConfig)
            
            Database.connect(dataSource)
            
            transaction {
                // Create tables if they don't exist
                // Add your tables here when needed
                // Example: SchemaUtils.create(Users, Posts)
                logger.info("Database connection verified successfully")
            }
            
            logger.info("Database connection established successfully")
        } catch (e: Exception) {
            logger.error("Failed to initialize database", e)
            throw e
        }
    }
    
    private fun createHikariDataSource(config: ApplicationConfig): HikariDataSource {
        val hikariConfig = HikariConfig().apply {
            jdbcUrl = config.property("url").getString()
            driverClassName = config.property("driver").getString()
            username = config.property("user").getString()
            password = config.property("password").getString()
            
            // Pool configuration
            maximumPoolSize = config.propertyOrNull("pool.maximumPoolSize")?.getString()?.toInt() ?: 10
            minimumIdle = config.propertyOrNull("pool.minimumIdle")?.getString()?.toInt() ?: 2
            idleTimeout = config.propertyOrNull("pool.idleTimeout")?.getString()?.toLong() ?: 600000
            connectionTimeout = config.propertyOrNull("pool.connectionTimeout")?.getString()?.toLong() ?: 30000
            maxLifetime = config.propertyOrNull("pool.maxLifetime")?.getString()?.toLong() ?: 1800000
            
            // Additional settings
            isAutoCommit = false
            transactionIsolation = "TRANSACTION_REPEATABLE_READ"
            
            // Connection test query for MySQL
            connectionTestQuery = "SELECT 1"
            
            // Leak detection (useful for development)
            config.propertyOrNull("pool.leakDetectionThreshold")?.getString()?.toLong()?.let {
                leakDetectionThreshold = it
            }
            
            validate()
        }
        
        return HikariDataSource(hikariConfig)
    }
}

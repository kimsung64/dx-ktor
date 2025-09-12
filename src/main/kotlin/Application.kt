package com.kinto.dx

import com.kinto.dx.config.DatabaseConfig.configureDatabases
import io.ktor.server.application.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.plugins.contentnegotiation.*
import kotlinx.serialization.json.Json

fun main(args: Array<String>) {
    // Load environment-specific config
    val env = System.getenv("KTOR_ENV") ?: "local"
    System.setProperty("config.file", "application-$env.yaml")
    
    io.ktor.server.netty.EngineMain.main(args)
}

fun Application.module() {
    // Configure JSON serialization
    install(ContentNegotiation) {
        json(Json {
            prettyPrint = true
            isLenient = true
        })
    }
    
    // Initialize database
    configureDatabases()
    
    // Configure routing
    configureRouting()
}

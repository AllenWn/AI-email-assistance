// main.go
package main

import (
	"AI-app/config"
	"AI-app/db"
	"AI-app/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Load configuration
	config.LoadConfig()

	// Initialize the database
	db.InitDatabase()

	// Set up routes
	routes.SetupRoutes(r)

	r.Run(":8080")
}

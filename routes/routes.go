package routes

import (
	"AI-app/API"
	"AI-app/controllers"
	"AI-app/middlewares"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	// Routes
	userGroup := r.Group("/user")
	{
		userGroup.POST("/register", controllers.RegisterUser)
		userGroup.POST("/login", controllers.LoginUser)

		// Add a protected route with authentication middleware
		userGroup.GET("/protected", middlewares.AuthMiddleware(), controllers.ProtectedEndpoint)
	}
	// Add other route groups for different parts of your API
	aiGroup := r.Group("/ai")
	{
		aiGroup.POST("/dalle", API.DalleHandler)
		aiGroup.POST("/email", API.EmailHandler)
	}
}

package controllers

import (
	"AI-app/db"
	"AI-app/models"
	"AI-app/utils"
	"github.com/gin-gonic/gin"
)

func LoginUser(c *gin.Context) {
	// Parse JSON request body
	var loginRequest struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&loginRequest); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	// Check if a user with the provided username exists
	var user models.User
	if err := db.DB.Where("username = ?", loginRequest.Username).First(&user).Error; err != nil {
		c.JSON(400, gin.H{"error": "User not found"})
		return
	}

	// Authenticate the user by comparing the provided password with the stored hashed password
	if !user.Authenticate(db.DB, loginRequest.Password) {
		c.JSON(401, gin.H{"error": "Invalid credentials"})
		return
	}

	// Generate a JWT token
	token, err := utils.GenerateToken(user.Username)
	if err != nil {
		c.JSON(500, gin.H{"error": "Failed to generate token"})
		return
	}

	// Return the token in the response
	c.JSON(200, gin.H{"token": token})
}

// generate a protected route that requires authentication.
func ProtectedEndpoint(c *gin.Context) {
	// Access the claims from the context (these contain user information)
	claims, _ := c.Get("claims")

	// Retrieve the username from the claims
	username := claims.(*utils.Claims).Username

	c.JSON(200, gin.H{"message": "Welcome, " + username})
}

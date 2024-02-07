package controllers

import (
	"AI-app/db"
	"AI-app/models"
	"github.com/gin-gonic/gin"
)

func RegisterUser(c *gin.Context) {
	// Parse JSON request body
	var registrationRequest struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&registrationRequest); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	// Check if the username or email is already registered
	var user models.User
	if err := db.DB.Where("username = ?", registrationRequest.Username).First(&user).Error; err == nil {
		c.JSON(400, gin.H{"error": "Username or email already exists"})
		return
	}

	// Create the user record in the database
	newUser := models.User{
		Username: registrationRequest.Username,
		Password: registrationRequest.Password, // Hash this password in production
	}

	if err := newUser.Create(db.DB); err != nil {
		c.JSON(500, gin.H{"error": "Failed to register user"})
		return
	}

	c.JSON(200, gin.H{"message": "User registered successfully"})
}

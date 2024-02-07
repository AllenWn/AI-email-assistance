package models

import (
	"AI-app/utils"
	"errors"
	"github.com/jinzhu/gorm"
	"golang.org/x/crypto/bcrypt"
)

var (
	ErrUserAlreadyExists = errors.New("user already exists")
)

type User struct {
	ID       uint   `gorm:"primary_key"`
	Username string `json:"username"`
	Password string `json:"-"`
}

func (u *User) Create(db *gorm.DB) error {
	// Check if a user with the same username or email already exists
	var existingUser User
	if err := db.Where("username = ?", u.Username).First(&existingUser).Error; err == nil {
		return ErrUserAlreadyExists
	}

	// Hash the user's password before storing it
	hashedPassword, err := utils.HashPassword(u.Password)
	if err != nil {
		return err
	}

	u.Password = hashedPassword

	// Create the user record in the database
	if err := db.Create(u).Error; err != nil {
		return err
	}

	return nil
}

func (u *User) Authenticate(db *gorm.DB, providedPassword string) bool {
	// Compare the provided password with the hashed password in the database
	return bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(providedPassword)) == nil
}

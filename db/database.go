package db

import (
	"AI-app/models"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
)

var (
	DB *gorm.DB
)

func InitDatabase() {
	// Connect to the database
	var err error
	DB, err = gorm.Open("mysql", "root:Ykz_20041107@tcp(localhost:3306)/myDB?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		panic("Failed to connect to the database")
	}

	// Automigrate the User model and any other models as needed
	DB.AutoMigrate(&models.User{})
}

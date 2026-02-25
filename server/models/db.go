package models

import (
	"strings"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	database, err := gorm.Open(sqlite.Open("database.db"), &gorm.Config{})
	if err != nil {
		panic("Failed to connect to database!")
	}
	DB = database

	DB.AutoMigrate(&Account{}, &BoughtDecoration{}, &Decoration{}, &Friend{}, &Score{})
}

func ErrorIsDuplicate(result *gorm.DB) bool {
	return strings.Contains(result.Error.Error(), "duplicate")
}

package services

import (
	"github.com/AuttakornC/Edudoro/server/models"
	"gorm.io/gorm"
)

func ScoreGetUserScore(db *gorm.DB, account_id string) (int, error) {
	var account models.Account

	err := db.Model(&models.Account{}).Preload("Scores").First(&account).Error
	if err != nil {
		return 0, err
	}

	var score int = 0

	for _, scoreHistory := range account.Scores {
		score += scoreHistory.Score
	}

	return score, nil
}

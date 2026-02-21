package models

import (
	"time"

	"gorm.io/gorm"
)

type Score struct {
	AccountId string    `gorm:"column:account_id;primaryKey" json:"-"`
	Score     int       `gorm:"column:score" json:"score"`
	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`
}

func (Score) TableName() string {
	return "scores"
}

func (s *Score) BeforeCreate(tx *gorm.DB) (err error) {
	s.CreatedAt = time.Now().Truncate(time.Millisecond)
	return
}

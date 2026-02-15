package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Account struct {
	AccountId string `gorm:"column:account_id;primaryKey" json:"account_id"`
	Email     string `gorm:"column:email;uniqueIndex" json:"email"`
	Password  string `gorm:"column:password" json:"password"`
}

func (Account) TableName() string {
	return "accounts"
}

func (b *Account) BeforeCreate(tx *gorm.DB) (err error) {
	b.AccountId = uuid.NewString()
	return
}

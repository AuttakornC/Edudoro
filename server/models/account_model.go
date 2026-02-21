package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Account struct {
	AccountId string `gorm:"column:account_id;primaryKey" json:"account_id"`
	Email     string `gorm:"column:email;uniqueIndex" json:"email"`
	Username  string `gorm:"column:username" json:"username"`
	Password  string `gorm:"column:password" json:"-"`

	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`

	Decorations []BoughtDecoration `gorm:"foreignKey:AccountId;references:AccountId" json:"decorations"`

	Friends []Friend `gorm:"foreignKey:RequesterId;references:AccountId" json:"friends"`

	Scores []Score `gorm:"foreignKey:AccountId;references:AccountId" json:"scores"`
}

func (Account) TableName() string {
	return "accounts"
}

func (b *Account) BeforeCreate(tx *gorm.DB) (err error) {
	b.AccountId = uuid.NewString()
	b.CreatedAt = time.Now().Truncate(time.Millisecond)
	return
}

type Friend struct {
	RequesterId string `gorm:"column:requester_id;primaryKey" json:"requester_id"`
	FriendId    string `gorm:"column:friend_id;primaryKey" json:"friend_id"`

	Requester Account `gorm:"foreignKey:RequesterId;references:AccountId" json:"requester"`
	Friend    Account `gorm:"foreignKey:FriendId;references:AccountId" json:"friend"`

	CreatedAt  time.Time  `gorm:"column:created_at" json:"created_at"`
	AcceptedAt *time.Time `gorm:"column:accepted_at" json:"accepted_at"`
}

func (Friend) TableName() string {
	return "friends"
}

func (b *Friend) BeforeCreate(tx *gorm.DB) (err error) {
	b.CreatedAt = time.Now().Truncate(time.Millisecond)
	return
}

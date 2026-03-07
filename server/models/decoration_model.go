package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type DecorationType string

const (
	DecorationIconType      DecorationType = "icon"
	DecorationFrameType     DecorationType = "frame"
	DecorationNameColorType DecorationType = "name_color"
)

type Decoration struct {
	DecorationId string         `gorm:"column:decoration_id;primaryKey" json:"decoration_id"`
	Type         DecorationType `gorm:"column:type" json:"type"`
	Detail       string         `gorm:"column:detail" json:"detail"`
	Price        int            `gorm:"column:price" json:"price"`

	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`

	OwnedUsers []BoughtDecoration `gorm:"foreignKey:DecorationId;references:DecorationId" json:"bought_decorations,omitempty"`
}

func (Decoration) TableName() string {
	return "decorations"
}

func (d *Decoration) BeforeCreate(tx *gorm.DB) (err error) {
	d.DecorationId = uuid.NewString()
	d.CreatedAt = time.Now().Truncate(time.Millisecond)
	return
}

type BoughtDecoration struct {
	AccountId    string `gorm:"column:account_id;primaryKey" json:"account_id"`
	DecorationId string `gorm:"column:decoration_id;primaryKey" json:"decoration_id"`
	Used         bool   `gorm:"column:used;default:false" json:"used"`

	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`

	Decoration Decoration `gorm:"foreignKey:DecorationId;references:DecorationId" json:"decoration"`
}

func (b *BoughtDecoration) BeforeCreate(tx *gorm.DB) (err error) {
	b.CreatedAt = time.Now().Truncate(time.Millisecond)
	return
}

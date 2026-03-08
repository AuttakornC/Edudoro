package controllers

import (
	"errors"
	"net/http"
	"time"

	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/utils"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type profileDecorations struct {
	DecorationId string                `json:"decoration_id"`
	Type         models.DecorationType `json:"type"`
	Detail       string                `json:"detail"`
	BoughtAt     time.Time             `json:"bought_at"`
}

type profileGetDetail struct {
	Username    string               `json:"username"`
	Email       string               `json:"email"`
	Decorations []profileDecorations `json:"decorations"`
}

func ProfileGetCurrentUsingDecorations(c *gin.Context) {
	accountId, _ := c.Get("account_id")

	var account models.Account

	err := models.DB.Preload("Decorations", "used = ?", true).
		Preload("Decorations.Decoration").
		Where("account_id = ?", accountId.(string)).
		First(&account).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			utils.RequestErrorHandlers(c, http.StatusNotFound, errors.New("user_not_found"))
			return
		}
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	var decorations []profileDecorations
	for _, decoration := range account.Decorations {
		decorations = append(decorations, profileDecorations{DecorationId: decoration.DecorationId, Type: decoration.Decoration.Type, Detail: decoration.Decoration.Detail, BoughtAt: decoration.CreatedAt})
	}

	profileDetail := profileGetDetail{
		Username:    account.Username,
		Email:       account.Email,
		Decorations: decorations,
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data":    profileDetail,
	})
}

func ProfileGetAllDecorations(c *gin.Context) {
	accountId, _ := c.Get("account_id")

	var account models.Account

	err := models.DB.Preload("Decorations").
		Preload("Decorations.Decoration").
		Where("account_id = ?", accountId.(string)).
		First(&account).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			utils.RequestErrorHandlers(c, http.StatusNotFound, errors.New("user_not_found"))
			return
		}
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	var decorations []profileDecorations
	for _, decoration := range account.Decorations {
		decorations = append(decorations, profileDecorations{DecorationId: decoration.DecorationId, Type: decoration.Decoration.Type, Detail: decoration.Decoration.Detail, BoughtAt: decoration.CreatedAt})
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data":    decorations,
	})
}

type profileUseDecocationRequestBody struct {
	DecorationId string `json:"decoration_id" binding:"required"`
}

func ProfileUseDecocation(c *gin.Context) {
	var body profileUseDecocationRequestBody

	if !utils.RequestValidateBody(c, &body) {
		return
	}

	accountId, _ := c.Get("account_id")

	err := models.DB.Transaction(func(tx *gorm.DB) error {
		var decoration models.Decoration

		err := tx.Where("decoration_id = ?", body.DecorationId).First(&decoration).Error
		if err != nil {
			return err
		}

		query := tx.Model(&models.BoughtDecoration{})

		result := query.Where("account_id = ?", accountId).Where("type = ?", decoration.Type).Update("used", false)
		if result.Error != nil {
			return result.Error
		}

		result = query.Where("account_id = ?", accountId).Where("decoration_id = ?", body.DecorationId).Update("used", true)
		if result.Error != nil {
			return result.Error
		}

		if result.RowsAffected == 0 {
			return errors.New("not_found_decoration")
		}

		return nil
	})

	if err != nil {
		if err.Error() == "not_found_decoration" || errors.Is(err, gorm.ErrRecordNotFound) {
			utils.RequestErrorHandlers(c, http.StatusNotFound, errors.New("decoration_not_found"))
			return
		}
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
	})
}

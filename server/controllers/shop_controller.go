package controllers

import (
	"errors"
	"net/http"

	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/services"
	"github.com/AuttakornC/Edudoro/server/utils"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type shopQueryAllDecorationsResponseBody struct {
	DecorationId string `json:"decoration_id"`
	Detail       string `json:"detail"`
	Owned        bool   `json:"owned"`
}

func ShopQueryAllDecorations(c *gin.Context) {
	accountId, isAuth := c.Get("account_id")

	var decorations []models.Decoration

	query := models.DB.Model(&models.Decoration{})

	if isAuth {
		query.Preload("OwnedUsers", "account_id = ?", accountId)
	}

	err := query.Order("type ASC").Find(&decorations).Error
	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	var icons, frames, nameColors []shopQueryAllDecorationsResponseBody

	for _, decoration := range decorations {
		switch decoration.Type {
		case models.DecorationIconType:
			icons = append(icons, shopQueryAllDecorationsResponseBody{DecorationId: decoration.DecorationId, Detail: decoration.Detail, Owned: len(decoration.OwnedUsers) != 0})
		case models.DecorationFrameType:
			frames = append(frames, shopQueryAllDecorationsResponseBody{DecorationId: decoration.DecorationId, Detail: decoration.Detail, Owned: len(decoration.OwnedUsers) != 0})
		case models.DecorationNameColorType:
			nameColors = append(nameColors, shopQueryAllDecorationsResponseBody{DecorationId: decoration.DecorationId, Detail: decoration.Detail, Owned: len(decoration.OwnedUsers) != 0})
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data": map[string][]shopQueryAllDecorationsResponseBody{
			"icons":       icons,
			"frames":      frames,
			"name_colors": nameColors,
		},
	})
}

type shopBuyDecorationRequestBody struct {
	DecorationId string `json:"decoration_id" binding:"required"`
}

func ShopBuyDecoration(c *gin.Context) {
	var body shopBuyDecorationRequestBody

	if !utils.RequestValidateBody(c, &body) {
		return
	}

	accountId, _ := c.Get("account_id")

	err := models.DB.Transaction(func(tx *gorm.DB) error {
		score, err := services.ScoreGetUserScore(tx, accountId.(string))
		if err != nil {
			return err
		}

		var decoration models.Decoration

		err = tx.Where("decoration_id = ?", body.DecorationId).First(&decoration).Error
		if err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return errors.New("decoration_not_found")
			}
			return err
		}

		if score < decoration.Price {
			return errors.New("not_enough_score")
		}

		newScoreHistory := models.Score{AccountId: accountId.(string), Score: -1 * decoration.Price}

		err = tx.Create(&newScoreHistory).Error

		newBoughtDecoration := models.BoughtDecoration{AccountId: accountId.(string), DecorationId: body.DecorationId, Used: false}

		err = tx.Create(&newBoughtDecoration).Error
		if err != nil {
			if errors.Is(err, gorm.ErrDuplicatedKey) {
				return errors.New("already_bought")
			}
			return err
		}

		return nil
	})
	if err != nil {
		errMsg := err.Error()
		switch errMsg {
		case "decoration_not_found":
			utils.RequestErrorHandlers(c, http.StatusNotFound, err)
			return
		case "not_enough_score":
			utils.RequestErrorHandlers(c, http.StatusPaymentRequired, err)
			return
		case "already_bought":
			utils.RequestErrorHandlers(c, http.StatusConflict, err)
			return
		}
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "success",
	})
}

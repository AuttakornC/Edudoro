package controllers

import (
	"net/http"

	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/services"
	"github.com/AuttakornC/Edudoro/server/utils"
	"github.com/gin-gonic/gin"
)

type scoreIncreaseRequest struct {
	Score int `json:"score" binding:"required"`
}

func ScoreIncrease(c *gin.Context) {
	var body scoreIncreaseRequest

	if !utils.RequestValidateBody(c, &body) {
		return
	}

	account_id, _ := c.Get("account_id")

	var newScore models.Score = models.Score{AccountId: account_id.(string), Score: body.Score}

	result := models.DB.Create(&newScore)

	if result.Error != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, result.Error)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "success"})

}

func ScoreGetOwnScore(c *gin.Context) {
	accountId, _ := c.Get("account_id")

	currentScore, err := services.ScoreGetUserScore(models.DB, accountId.(string))
	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data": map[string]int{
			"score": currentScore,
		},
	})
}

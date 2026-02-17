package controllers

import (
	"errors"
	"net/http"

	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/utils"
	"github.com/gin-gonic/gin"
)

type signInRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

func AuthSignIn(c *gin.Context) {
	var body signInRequest

	if !utils.RequestValidateBody(c, &body) {
		return
	}

	var account models.Account
	models.DB.Where("email = ?", body.Email).First(&account)

	if account.AccountId == "" {
		utils.RequestErrorHandlers(c, http.StatusNotFound, errors.New("account_not_found"))
		return
	}

	if !utils.CryptCheckPasswordHash(body.Password, account.Password) {
		utils.RequestErrorHandlers(c, http.StatusBadRequest, errors.New("password_not_match"))
		return
	}

	token, err := utils.JWTCreateToken(account.AccountId)
	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data": map[string]string{
			"token": token,
		},
	})
}

type signUpRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

func AuthSignUp(c *gin.Context) {
	var body signUpRequest

	if !utils.RequestValidateBody(c, &body) {
		return
	}

	hashedPassword, err := utils.CryptHashPassword(body.Password)
	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	newAccount := models.Account{Email: body.Email, Password: hashedPassword}
	result := models.DB.Create(&newAccount)

	if result.Error != nil {
		utils.RequestErrorHandlers(c, 500, result.Error)
	}

	c.JSON(http.StatusOK, gin.H{"message": "success"})
}

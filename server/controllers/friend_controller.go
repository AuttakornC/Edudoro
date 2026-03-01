package controllers

import (
	"errors"
	"net/http"
	"slices"
	"time"

	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/utils"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type friendAcceptResponseBody struct {
	FriendId   string    `json:"friend_account_id"`
	DailyScore int       `json:"daily_score"`
	FriendAt   time.Time `json:"friend_at"`
}

func FriendAcceptedQuery(c *gin.Context) {
	accountId, _ := c.Get("account_id")

	var account models.Account

	today := time.Now().Truncate(24 * time.Hour)

	err := models.DB.Preload("FriendsFromRequest", "accepted_at IS NOT NULL").
		Preload("FriendsFromRequest.Friend").
		Preload("FriendsFromRequest.Friend.Scores", "created_at >= ?", today).
		Preload("FriendsFromAcception", "accepted_at IS NOT NULL").
		Preload("FriendsFromAcception.Requester").
		Preload("FriendsFromAcception.Requester.Scores", "created_at >= ?", today).
		First(&account, "account_id = ?", accountId).Error

	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	var FriendsList []friendAcceptResponseBody

	for _, friend := range account.FriendsFromRequest {
		var friendTodayScore int = 0
		for _, scoreHistory := range friend.Friend.Scores {
			friendTodayScore += scoreHistory.Score
		}
		FriendsList = append(FriendsList, friendAcceptResponseBody{FriendId: friend.FriendId, FriendAt: *friend.AcceptedAt, DailyScore: friendTodayScore})
	}

	for _, friend := range account.FriendsFromAcception {
		var friendTodayScore int = 0
		for _, scoreHistory := range friend.Requester.Scores {
			friendTodayScore += scoreHistory.Score
		}
		FriendsList = append(FriendsList, friendAcceptResponseBody{FriendId: friend.RequesterId, FriendAt: *friend.AcceptedAt, DailyScore: friendTodayScore})
	}

	slices.SortFunc(FriendsList, func(a, b friendAcceptResponseBody) int {
		return b.DailyScore - a.DailyScore
	})

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data":    FriendsList,
	})
}

type friendRequestRequestBody struct {
	UserName string `json:"username" binding:"required"`
}

func FriendRequest(c *gin.Context) {
	var body friendRequestRequestBody

	if !utils.RequestValidateBody(c, &body) {
		return
	}

	var friendAccount models.Account

	err := models.DB.Select("account_id").Where("username = ?", body.UserName).First(&friendAccount).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			utils.RequestErrorHandlers(c, http.StatusNotFound, errors.New("user_not_found"))
			return
		}
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	accountId, _ := c.Get("account_id")
	if accountId == friendAccount.AccountId {
		utils.RequestErrorHandlers(c, http.StatusBadRequest, errors.New("same_account_id"))
		return
	}

	var existing models.Friend
	err = models.DB.Where(
		"(requester_id = ? AND friend_id = ?) OR (requester_id = ? AND friend_id = ?)",
		accountId, friendAccount.AccountId, friendAccount.AccountId, accountId,
	).First(&existing).Error

	if err == nil {
		utils.RequestErrorHandlers(c, http.StatusConflict, errors.New("already_requested"))
		return
	}

	if !errors.Is(err, gorm.ErrRecordNotFound) {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	newFriendRequest := models.Friend{
		RequesterId: accountId.(string),
		FriendId:    friendAccount.AccountId,
		AcceptedAt:  nil,
	}

	err = models.DB.Create(&newFriendRequest).Error
	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "success"})

}

type friendRequestQueryDecoration struct {
	Type   models.DecorationType `json:"type"`
	Detail string                `json:"detail"`
}

type friendRequestQueryResponse struct {
	RequestId   string                         `json:"request_id"`
	Username    string                         `json:"username"`
	Decorations []friendRequestQueryDecoration `json:"decorations"`
}

func FriendRequestQuery(c *gin.Context) {
	account_id, _ := c.Get("account_id")
	var friendsRequest []models.Friend
	err := models.DB.Preload("Requester").
		Preload("Requester.Decorations", "used = ?", true).
		Preload("Requester.Decorations.Decoration").
		Where("friend_id = ? AND accepted_at IS NULL", account_id).
		Order("created_at DESC").
		Find(&friendsRequest).Error

	if err != nil {
		utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
		return
	}

	var responseBody []friendRequestQueryResponse

	for _, friendRequest := range friendsRequest {
		var decorations []friendRequestQueryDecoration
		for _, decoration := range friendRequest.Requester.Decorations {
			decorations = append(decorations, friendRequestQueryDecoration{Type: decoration.Decoration.Type, Detail: decoration.Decoration.Detail})
		}
		responseBody = append(responseBody, friendRequestQueryResponse{RequestId: friendRequest.RequesterId, Username: friendRequest.Requester.Username, Decorations: decorations})
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "success",
		"data":    responseBody,
	})
}

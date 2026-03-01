package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/AuttakornC/Edudoro/server/middlewares"
	"github.com/gin-gonic/gin"
)

func friendRouteSetup(r *gin.RouterGroup) {
	friendRoute := r.Group("/friend")

	friendRoute.Use(middlewares.AuthMiddleware())

	friendRoute.GET("", controllers.FriendAcceptedQuery)
	friendRoute.GET("/request", controllers.FriendRequestQuery)
	friendRoute.POST("/request", controllers.FriendRequest)
}

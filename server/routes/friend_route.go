package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/AuttakornC/Edudoro/server/middlewares"
	"github.com/gin-gonic/gin"
)

func friendRouteSetup(r *gin.RouterGroup) {
	friendRoute := r.Group("/friends")

	friendRoute.Use(middlewares.AuthMiddleware())

	friendRoute.GET("", controllers.FriendAcceptedQuery)
	friendRoute.GET("/requests", controllers.FriendRequestQuery)
	friendRoute.GET("/request", controllers.FriendAcceptedQuery)
	friendRoute.POST("/request", controllers.FriendRequest)
	friendRoute.PATCH("/request", controllers.FriendRequestResponse)
	friendRoute.DELETE("/request/:request_id", controllers.FriendRequestDenied)
}

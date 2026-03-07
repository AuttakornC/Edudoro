package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/AuttakornC/Edudoro/server/middlewares"
	"github.com/gin-gonic/gin"
)

func shopRouteSetup(r *gin.RouterGroup) {
	shopRoute := r.Group("/shop")

	shopRoute.GET("/decorations", middlewares.AuthOptionalMiddleware(), controllers.ShopQueryAllDecorations)

	shopRoute.Use(middlewares.AuthMiddleware())

	shopRoute.POST("/buy", controllers.ShopBuyDecoration)
}

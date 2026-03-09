package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/AuttakornC/Edudoro/server/middlewares"
	"github.com/gin-gonic/gin"
)

func profileRouteSetup(r *gin.RouterGroup) {
	profileRoute := r.Group("/profile")

	profileRoute.Use(middlewares.AuthMiddleware())
	profileRoute.GET("", controllers.ProfileGetCurrentUsingDecorations)
	profileRoute.GET("/decorations", controllers.ProfileGetAllDecorations)
	profileRoute.PATCH("/use", controllers.ProfileUseDecocation)
}

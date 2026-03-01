package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/AuttakornC/Edudoro/server/middlewares"
	"github.com/gin-gonic/gin"
)

func scoreRouteSetup(r *gin.RouterGroup) {
	scoreRoute := r.Group("/score")

	scoreRoute.Use(middlewares.AuthMiddleware())

	scoreRoute.POST("", controllers.ScoreIncrease)
}

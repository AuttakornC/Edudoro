package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/gin-gonic/gin"
)

func authRouteSetup(r *gin.RouterGroup) {
	authRoute := r.Group("/auth")
	authRoute.POST("/sign-in", controllers.AuthSignIn)
	authRoute.POST("/sign-up", controllers.AuthSignUp)
}

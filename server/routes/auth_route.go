package routes

import (
	"github.com/AuttakornC/Edudoro/server/controllers"
	"github.com/gin-gonic/gin"
)

func authRouteSetup(r *gin.RouterGroup) {
	authRoute := r.Group("/auth")
	{
		authRoute.POST("/sign-in", controllers.AuthSignIn)
		authRoute.GET("/sign-in", func(ctx *gin.Context) { ctx.String(200, "Hello, Sign In.") })
		authRoute.POST("/sign-up", controllers.AuthSignUp)
	}
}

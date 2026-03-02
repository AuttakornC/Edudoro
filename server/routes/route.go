package routes

import (
	"net/http"

	"github.com/AuttakornC/Edudoro/server/middlewares"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"}
	config.AllowMethods = []string{"POST", "GET", "OPTIONS", "PUT", "DELETE", "PATCH"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization"}

	r.Use(cors.New(config))
	r.Use(middlewares.ErrorHandleMiddleware())

	v1 := r.Group("/api/v1")
	{
		v1.GET("/health", func(c *gin.Context) { c.String(http.StatusOK, "Good!!") })
		authRouteSetup(v1)
		scoreRouteSetup(v1)
		friendRouteSetup(v1)
	}

	return r
}

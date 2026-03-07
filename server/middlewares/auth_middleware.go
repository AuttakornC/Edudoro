package middlewares

import (
	"errors"
	"net/http"
	"strings"

	"github.com/AuttakornC/Edudoro/server/utils"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authorization := c.Request.Header.Get("Authorization")

		token, found := strings.CutPrefix(authorization, "Bearer ")

		if authorization == "" || !found {
			utils.RequestErrorHandlers(c, http.StatusUnauthorized, errors.New("unauthorized"))
			c.Abort()
			return
		}

		payload, err := utils.JWTValidateToken(token)

		if err != nil {
			utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
			c.Abort()
			return
		}

		claims, ok := payload.Claims.(jwt.MapClaims)
		if !ok || !payload.Valid {
			utils.RequestErrorHandlers(c, http.StatusUnauthorized, errors.New("unauthorized"))
			c.Abort()
			return
		}

		c.Set("account_id", claims["account_id"].(string))

		c.Next()
	}
}

func AuthOptionalMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authorization := c.Request.Header.Get("Authorization")

		token, found := strings.CutPrefix(authorization, "Bearer ")

		if authorization == "" || !found {
			c.Next()
			return
		}

		payload, err := utils.JWTValidateToken(token)

		if err != nil {
			utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
			c.Abort()
			return
		}

		claims, ok := payload.Claims.(jwt.MapClaims)
		if !ok || !payload.Valid {
			utils.RequestErrorHandlers(c, http.StatusUnauthorized, errors.New("unauthorized"))
			c.Abort()
			return
		}

		c.Set("account_id", claims["account_id"].(string))

		c.Next()
	}
}

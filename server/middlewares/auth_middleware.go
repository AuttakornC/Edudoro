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

		if !found {
			utils.RequestErrorHandlers(c, http.StatusUnauthorized, errors.New("unauthorized"))
			return
		}

		payload, err := utils.JWTValidateToken(token)

		if err != nil {
			utils.RequestErrorHandlers(c, http.StatusInternalServerError, err)
			return
		}

		claims, ok := payload.Claims.(jwt.MapClaims)
		if !ok || !payload.Valid {
			utils.RequestErrorHandlers(c, http.StatusUnauthorized, errors.New("unauthorized"))
			return
		}

		c.Set("account_id", claims["account_id"].(string))

		c.Next()
	}
}

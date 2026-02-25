package utils

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func RequestErrorHandlers(c *gin.Context, status int, err error) {
	c.Status(status)
	c.Error(err)
}

func RequestValidateBody(c *gin.Context, obj interface{}) bool {
	if err := c.ShouldBindJSON(obj); err != nil {
		RequestErrorHandlers(c, http.StatusBadRequest, err)
		return false
	}
	return true
}

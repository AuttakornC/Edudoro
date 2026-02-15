package main

import (
	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/routes"
)

func main() {
	models.ConnectDatabase()

	r := routes.SetupRouter()
	r.Run(":3000")
}

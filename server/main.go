package main

import (
	"log"
	"os"

	"github.com/AuttakornC/Edudoro/server/models"
	"github.com/AuttakornC/Edudoro/server/routes"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatalln("Can't load env:", err)
	}

	models.ConnectDatabase()

	err = models.SeedDatabase(models.DB)
	if err != nil {
		log.Fatal(err)
	}

	r := routes.SetupRouter()
	r.Run(":" + os.Getenv("PORT"))
}
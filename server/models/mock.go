package models

import (
	"fmt"
	"math/rand"
	"os"
	"time"

	"github.com/AuttakornC/Edudoro/server/utils"
	"gorm.io/gorm"
)

func randomString(n int) string {
	var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
	s := make([]rune, n)
	for i := range s {
		s[i] = letters[rand.Intn(len(letters))]
	}
	return string(s)
}

func SeedDatabase(db *gorm.DB) error {
	rand.Seed(time.Now().UnixNano())

	// 1. Seed Decorations (The Catalog)
	decorations := []Decoration{
		{Type: DecorationIconType, Detail: "fire_emblem", Price: 150},
		{Type: DecorationIconType, Detail: "water_drop", Price: 150},
		{Type: DecorationFrameType, Detail: "golden_luxury", Price: 2000},
		{Type: DecorationNameColorType, Detail: "#F54927", Price: 500},
	}
	if err := db.Create(&decorations).Error; err != nil {
		return err
	}

	password, err := utils.CryptHashPassword("password")
	if err != nil {
		return err
	}

	file, err := os.Create("mock_accounts.txt")
	if err != nil {
		return fmt.Errorf("could not create credentials file: %w", err)
	}
	defer file.Close()

	fmt.Fprintln(file, "--- MOCK USER CREDENTIALS ---")
	fmt.Fprintln(file, "Format: Username | Email")
	fmt.Fprintln(file, "-----------------------------")

	// 2. Seed Accounts
	numAccounts := 10
	accounts := make([]Account, numAccounts)
	for i := 0; i < numAccounts; i++ {
		suffix := randomString(5)
		accounts[i] = Account{
			Username: fmt.Sprintf("User_%s", suffix),
			Email:    fmt.Sprintf("user_%s@example.com", suffix),
			Password: password,
		}
		fmt.Fprintf(file, "%s | %s\n", accounts[i].Username, accounts[i].Email)
	}
	if err := db.Create(&accounts).Error; err != nil {
		return err
	}

	// 3. Seed Relationships (Scores and Owned Decorations)
	for _, acc := range accounts {
		// Assign 1 random decoration to each user
		randomDecID := decorations[rand.Intn(len(decorations))].DecorationId
		bought := BoughtDecoration{
			AccountId:    acc.AccountId,
			DecorationId: randomDecID,
			Used:         rand.Intn(2) == 1, // 50% chance of being equipped
		}
		db.Create(&bought)

		// Create 3 historical scores per user
		for j := 0; j < 3; j++ {
			db.Create(&Score{
				AccountId: acc.AccountId,
				Score:     rand.Intn(5000) + 100,
				// Stagger the dates by 1 day each
				CreatedAt: time.Now().AddDate(0, 0, -j),
			})
		}
	}

	// 4. Seed Friends (Circular logic to ensure everyone has 1 friend)
	for i := 0; i < len(accounts); i++ {
		friendIdx := (i + 1) % len(accounts) // Link current user to the next one
		now := time.Now()

		friendship := Friend{
			RequesterId: accounts[i].AccountId,
			FriendId:    accounts[friendIdx].AccountId,
			AcceptedAt:  &now,
		}
		db.Create(&friendship)
	}

	fmt.Println("Successfully seeded data using standard library!")
	return nil
}

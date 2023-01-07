package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// ConfirmCode renders reset page
func ConfirmCode(c *fiber.Ctx) error {
	query := c.Query("code")
	if len(query) != 20 {
		return errorHandler.BadRequest(c)
	}

	//query code from database
	rows := database.DB.QueryRow("SELECT userId,username,email FROM users WHERE code = ?", query)

	var dbUser models.User
	err := rows.Scan(&dbUser.ID, &dbUser.Username, &dbUser.Email)

	if err != nil {
		return errorHandler.BadRequest(c)
	}

	claims := jwt.MapClaims{
		"sub":      dbUser.ID,
		"username": dbUser.Username,
		"email":    dbUser.Email,
		"exp":      time.Now().Add(time.Hour * 1).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString(database.Secret)
	if err != nil {
		return errorHandler.InternalServerError(c)

	}

	go database.Lof.Println("User | ConfirmCode fetched successfully by", dbUser.ID)

	return c.Render("reset", fiber.Map{
		"title": dbUser.Username,
		"type":  "user",
		"token": t,
	})
}

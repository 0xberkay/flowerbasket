package user

import (
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Profile renders profile page
func Profile(c *fiber.Ctx) error {
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	user := models.User{
		ID:       uint(claims["sub"].(float64)),
		Username: claims["username"].(string),
		Email:    claims["email"].(string),
	}

	go database.Lof.Println("User | Profile fetched successfully by", user.ID)

	return c.JSON(user)
}

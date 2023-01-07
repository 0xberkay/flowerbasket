package all

import (
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Check checks if the user is logged in and returns the user credentials
func Check(c *fiber.Ctx) error {

	h := c.Get("Authorization")
	//delete the Bearer part
	if len(h) > 7 {
		if h[0:7] == "Bearer " {
			h = h[7:]
		}
	}
	jwtToken, err := jwt.Parse(h, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, jwt.ErrInvalidKey
		}
		return database.Secret, nil
	})
	if err != nil {
		jwtToken, err = jwt.Parse(h, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrInvalidKey
			}
			return database.Secret2, nil
		})
		if err != nil {
			return c.SendStatus(fiber.StatusUnauthorized)
		}
		if claims, ok := jwtToken.Claims.(jwt.MapClaims); ok && jwtToken.Valid {
			userData := models.CheckUser{
				ID:       uint(claims["sub"].(float64)),
				Username: claims["company"].(string),
				IsSeller: true,
			}
			return c.Status(fiber.StatusOK).JSON(userData)
		}
	}
	if claims, ok := jwtToken.Claims.(jwt.MapClaims); ok && jwtToken.Valid {
		userData := models.CheckUser{
			ID:       uint(claims["sub"].(float64)),
			Username: claims["username"].(string),
			IsSeller: false,
		}
		return c.Status(fiber.StatusOK).JSON(userData)
	}

	return c.SendStatus(fiber.StatusUnauthorized)
}

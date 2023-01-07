package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Update updates seller's email
func Update(c *fiber.Ctx) error {
	var user models.Email

	if err := c.BodyParser(&user); err != nil {
		return errorHandler.BadRequest(c)
	}

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userId := uint(claims["sub"].(float64))
	userMail := claims["email"].(string)

	if user.Email == userMail {
		return errorHandler.NoChanges(c)
	}

	err := models.Validate.Struct(user)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" && err.Field() == "Email" {
				return errorHandler.RequiredField(c, err.Field())
			}
			if err.Tag() == "min" {
				return errorHandler.MinLength(c, err.Field(), err.Param())
			}
			if err.Tag() == "max" {
				return errorHandler.MaxLength(c, err.Field(), err.Param())

			}
			if err.Tag() == "email" {
				return errorHandler.EmailIsNotValid(c)
			}
		}
	}

	// Update user
	_, err = database.DB.Exec("UPDATE sellers SET email = ? WHERE sellerId = ?", user.Email, userId)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	claims["email"] = user.Email

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString(database.Secret2)
	if err != nil {
		return errorHandler.InternalServerError(c)

	}

	go database.Lof.Println("Seller | Email changed successfully by", userId)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": t,
	})
}

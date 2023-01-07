package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// UpdateMessage updates user message and updates it in db
func UpdateMessage(c *fiber.Ctx) error {
	// Retrieve the user's ID from the JWT
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	var message models.CartMessage
	if err := c.BodyParser(&message); err != nil {
		return errorHandler.BadRequest(c)
	}

	err := models.Validate.Struct(message)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" {
				return errorHandler.RequiredField(c, err.Field())
			}
			if err.Tag() == "min" {
				return errorHandler.MinLength(c, err.Field(), err.Param())
			}
			if err.Tag() == "max" {
				return errorHandler.MaxLength(c, err.Field(), err.Param())
			}
		}
	}

	//update message
	_, err = database.DB.Exec(
		`UPDATE cm
		SET cm.[message] = ?, cm.nameInMessage = ? 
		FROM CartMessages cm
		JOIN Carts c ON cm.cartId = c.cartId 
		WHERE c.cartId = ? AND c.userId = ?
		`,
		message.Message,
		message.Name,
		message.CartID,
		userID,
	)
	if err != nil {
		//fmt.Println(err)
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | message updated successfully", userID)

	// Return a success response to the client
	return c.Status(fiber.StatusOK).JSON(
		fiber.Map{
			"message": "message updated successfully",
		},
	)
}

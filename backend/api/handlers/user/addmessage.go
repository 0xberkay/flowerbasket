package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// AddMessage adds message to cart
func AddMessage(c *fiber.Ctx) error {

	var message models.CartMessage
	if err := c.BodyParser(&message); err != nil {
		return errorHandler.BadRequest(c)
	}
	//fmt.Println("message: ", message)
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

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userId := uint(claims["sub"].(float64))

	//check message.CartID and userId is valid in database
	cartId := c.Query("c")
	if cartId == "" {
		return errorHandler.BadRequest(c)
	}
	err = database.DB.QueryRow("SELECT cartId FROM carts WHERE cartId = ? AND userId = ?", cartId, userId).Scan(&message.CartID)
	if err != nil {
		return errorHandler.UnauthorizedDef(c)
	}

	//insert message
	_, err = database.DB.Exec("INSERT INTO cartMessages (cartId,message,nameInMessage) VALUES (?,?,?)", message.CartID, message.Message, message.Name)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | Message added successfully by", userId)

	return c.JSON(fiber.Map{
		"message": "Message added",
	})
}

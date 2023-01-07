package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// GetMessage retrieves the message from the database
func GetMessage(c *fiber.Ctx) error {
	// Retrieve the user's ID from the JWT
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	cartId := c.Query("cartId")
	if cartId == "" {
		return errorHandler.BadRequest(c)
	}

	// Retrieve the user's addresses from the database
	rows := database.DB.QueryRow(`SELECT  
	cm.messageId,cm.cartId,cm.[message],cm.nameInMessage
	FROM Carts c 
	JOIN CartMessages cm ON c.cartId = cm.cartId
	WHERE c.cartId = ? AND c.userId = ?
	`, cartId, userID)

	var message models.CartMessage

	err := rows.Scan(&message.CartID, &message.MessageID, &message.Name, &message.Message)
	if err != nil {
		//fmt.Println("User | error retrieving message", err)
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | message retrieved successfully", userID)

	// Return the addresses in the response
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"cart_message": message,
	})
}

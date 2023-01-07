package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// DeleteFromCart deletes product from cart
func DeleteMessage(c *fiber.Ctx) error {
	// Retrieve the user's ID from the JWT
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	cartID := c.Query("c")
	if cartID == "" {
		return errorHandler.BadRequest(c)
	}

	//update message
	_, err := database.DB.Exec(
		`UPDATE Carts SET messageId = 0 
		WHERE cartId = ? AND userId = ?
		`,
		cartID,
		userID,
	)
	if err != nil {
		//fmt.Println(err)
		return errorHandler.InternalServerError(c)
	}

	// Delete the message from the database
	_, err = database.DB.Exec(
		`DELETE FROM CartMessages WHERE cartId = ?`,
		cartID,
	)
	if err != nil {
		//fmt.Println(err)
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | message deleted successfully", userID)

	// Return a success response to the client
	return c.Status(fiber.StatusOK).JSON(
		fiber.Map{
			"message": "Message deleted successfully",
		},
	)
}

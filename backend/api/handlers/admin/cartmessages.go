package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// CartMessages returns all cart messages
func CartMessages(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM CartMessages")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var cartMessages []models.CartMessageAdmin
	for rows.Next() {
		var cartMessage models.CartMessageAdmin
		err := rows.Scan(&cartMessage.MessageId, &cartMessage.CartId, &cartMessage.Message, &cartMessage.NameInMessage)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		cartMessages = append(cartMessages, cartMessage)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"cartMessages": cartMessages,
	})
}

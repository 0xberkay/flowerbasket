package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// CartMessages returns all cart messages
func Carts(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Carts")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var carts []models.CartAdmin
	for rows.Next() {
		var cart models.CartAdmin
		err := rows.Scan(&cart.CartId, &cart.UserId, &cart.ProductId, &cart.Count, &cart.Price, &cart.MessageId)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		carts = append(carts, cart)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"carts": carts,
	})
}

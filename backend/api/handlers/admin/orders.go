package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Orders returns all orders
func Orders(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Orders")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var orders []models.OrderAdmin
	for rows.Next() {
		var order models.OrderAdmin
		err := rows.Scan(&order.OrderId, &order.UserId, &order.ProductId, &order.ProductCount, &order.StatuId, &order.AddressId, &order.CreatedAt, &order.MessageId)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		orders = append(orders, order)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"orders": orders,
	})
}

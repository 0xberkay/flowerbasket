package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Orders returns all orders
func Products(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Products")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var products []models.ProductAdmin

	for rows.Next() {
		var product models.ProductAdmin
		err := rows.Scan(&product.ProductId, &product.ProductName, &product.SellerId, &product.Description, &product.ImageId, &product.Price, &product.Stock, &product.CreatedAt, &product.CategoryId, &product.Point)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		products = append(products, product)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"products": products,
	})
}

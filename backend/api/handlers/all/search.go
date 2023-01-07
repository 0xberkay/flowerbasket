package all

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Search returns search results
func Search(c *fiber.Ctx) error {
	query := c.Query("q")

	rows, err := database.DB.Query(`EXEC SearchProduct ?`, query)

	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	var products []models.AllProduct
	for rows.Next() {
		var product models.AllProduct
		err = rows.Scan(&product.ID, &product.Company, &product.SellerID, &product.ProductName, &product.Description, &product.Price, &product.Stock, &product.CategoryName, &product.Link, &product.Point)
		if err != nil {
			//fmt.Println("error", err.Error())
			return errorHandler.InternalServerError(c)
		}
		product.Link = c.BaseURL() + "/images/" + product.Link

		products = append(products, product)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"products": products,
	})
}

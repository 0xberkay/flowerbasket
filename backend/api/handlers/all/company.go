package all

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// CompanyProducts returns all products of a company
func CompanyProducts(c *fiber.Ctx) error {
	company := c.Query("c")
	rows, err := database.DB.Query("SELECT productId,company, productName, description, price, stock,categoryName, link,point FROM TrustedProducts WHERE company = ?", company)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	var products []models.AllProduct
	for rows.Next() {
		var product models.AllProduct
		err = rows.Scan(&product.ID, &product.Company, &product.ProductName, &product.Description, &product.Price, &product.Stock, &product.CategoryName, &product.Link, &product.Point)
		if err != nil {
			return errorHandler.InternalServerError(c)
		}
		product.Link = c.BaseURL() + "/images/" + product.Link
		products = append(products, product)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"products": products,
	})
}

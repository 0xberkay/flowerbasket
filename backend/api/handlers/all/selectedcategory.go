package all

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// SelectedCategory returns all products in selected category
func SelectedCategory(c *fiber.Ctx) error {

	query := c.Query("c")

	rows, err := database.DB.Query(`
	SELECT  productId,Sellers.company,Sellers.sellerId, productName, description, price, stock, Categories.categoryName, Images.link,Products.point
	FROM products JOIN categories
	ON categories.categoryID = products.categoryID
	JOIN sellers
    ON Sellers.sellerId = Products.sellerId
    JOIN images
	ON Images.imageId = Products.imageId
    WHERE Sellers.trust = 1 AND Products.categoryId = ?`, query)
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

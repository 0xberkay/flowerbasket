package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// GetProducts returns products of seller
func GetProducts(c *fiber.Ctx) error {
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	rows, err := database.DB.Query(`
	SELECT productId,productName,description,price,stock,createdAt,Categories.categoryName,Images.link
	FROM products JOIN Categories
	 on Categories.categoryID = Products.categoryID
	 JOIN Images 
	 on Images.imageId = Products.imageId
	 WHERE Products.sellerId = ?
	`, uint(claims["sub"].(float64)))
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	var products []models.Product
	for rows.Next() {
		var product models.Product
		err = rows.Scan(&product.ID, &product.Name, &product.Description, &product.Price, &product.Stock, &product.CreatedAt, &product.CategoryName, &product.ImageLink)
		if err != nil {
			return errorHandler.InternalServerError(c)
		}
		product.ImageLink = c.BaseURL() + "/images/" + product.ImageLink

		products = append(products, product)
	}

	go database.Lof.Println("Seller | Products fetched successfully by", uint(claims["sub"].(float64)))

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"seller_products": products,
	})
}

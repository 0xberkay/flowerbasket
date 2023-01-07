package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// AddProduct adds product to database
func AddProduct(c *fiber.Ctx) error {
	var product models.Product
	if err := c.BodyParser(&product); err != nil {
		//fmt.Println(err)
		return errorHandler.BadRequest(c)
	}

	// Validate product
	err := models.Validate.Struct(product)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" {
				return errorHandler.RequiredField(c, err.Field())
			}
			if err.Tag() == "min" {
				return errorHandler.MinLength(c, err.Field(), err.Param())
			}
			if err.Tag() == "max" {
				return errorHandler.MaxLength(c, err.Field(), err.Param())
			}
		}
	}
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	sellerId := uint(claims["sub"].(float64))
	// Add product
	_, err = database.DB.Exec("INSERT INTO products (productName,sellerId,description,price,stock,categoryId,imageId) VALUES (?, ?, ?, ?, ?, ?, ?)",
		product.Name,
		sellerId,
		product.Description,
		product.Price,
		product.Stock,
		product.CategoryID,
		product.ImageID,
	)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("Seller | Product added successfully by", sellerId)

	return c.JSON(fiber.Map{
		"message": "Product added successfully",
	})
}

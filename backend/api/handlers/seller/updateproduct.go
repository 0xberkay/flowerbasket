package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// UpdateProduct updates seller's product
func UpdateProduct(c *fiber.Ctx) error {
	var product models.Product
	if err := c.BodyParser(&product); err != nil {
		return errorHandler.BadRequest(c)
	}

	if c.Query("id") == "" {
		return errorHandler.BadRequest(c)
	}

	err := models.Validate.Struct(product)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
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

	query := "UPDATE products SET"
	args := []interface{}{}

	if product.Name != "" {
		query += " productName = ?,"
		args = append(args, product.Name)
	}
	if product.Description != "" {
		query += " description = ?,"
		args = append(args, product.Description)
	}
	if product.Price != 0 {
		query += " price = ?,"
		args = append(args, product.Price)
	}
	if product.Stock != 0 {
		query += " stock = ?,"
		args = append(args, product.Stock)
	}
	if product.CategoryID != 0 {
		query += " categoryId = ?,"
		args = append(args, product.CategoryID)
	}
	if product.ImageID != 0 {
		query += " imageId = ?,"
		args = append(args, product.ImageID)
	}
	query = query[:len(query)-1] + " WHERE sellerId = ? AND productId = ?"
	//fmt.Println(query)
	args = append(args, uint(claims["sub"].(float64)), c.Query("id"))
	result, err := database.DB.Exec(query, args...)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	if count, _ := result.RowsAffected(); count == 0 {
		return errorHandler.NotFoundProduct(c)
	}

	go database.Lof.Println("Seller | Product updated successfully by", claims["sub"].(float64))

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Product updated successfully",
	})
}

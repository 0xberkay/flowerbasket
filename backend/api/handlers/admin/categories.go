package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Categories returns all categories
func Categories(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Categories")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var categories []models.CategoryAdmin
	for rows.Next() {
		var category models.CategoryAdmin
		err := rows.Scan(&category.CategoryId, &category.CategoryName)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		categories = append(categories, category)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"categories": categories,
	})
}

package all

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Categories returns all categories
func Categories(c *fiber.Ctx) error {

	rows, err := database.DB.Query("EXEC SelectAllCategories")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var catagories []models.Category
	for rows.Next() {
		var category models.Category
		err := rows.Scan(&category.CategoryID, &category.CategoryName)
		if err != nil {
			return errorHandler.InternalServerError(c)
		}
		catagories = append(catagories, category)
	}

	return c.JSON(fiber.Map{
		"categories": catagories,
	})
}

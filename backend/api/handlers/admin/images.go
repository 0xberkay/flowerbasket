package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Categories returns all categories
func Images(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Images")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var images []models.ImagesAdmin
	for rows.Next() {
		var image models.ImagesAdmin
		err := rows.Scan(&image.ImageId, &image.SellerId, &image.Link)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		image.Link = c.BaseURL() + "/images/" + image.Link

		images = append(images, image)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"images": images,
	})
}

package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// GetGallery returns seller's gallery
func GetGallery(c *fiber.Ctx) error {
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userId := uint(claims["sub"].(float64))

	//find user images in database

	rows, err := database.DB.Query("SELECT link,imageId FROM images WHERE sellerId = ?", userId)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	var images []models.Image
	for rows.Next() {
		var image models.Image
		err = rows.Scan(&image.Link, &image.ID)
		if err != nil {
			return errorHandler.InternalServerError(c)
		}
		image.Link = c.BaseURL() + "/images/" + image.Link

		images = append(images, image)
	}

	go database.Lof.Println("Seller | Gallery fetched successfully by", userId)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"gallery": images,
	})
}

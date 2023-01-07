package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Delete deletes image from database and folder
func Delete(c *fiber.Ctx) error {

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userId := uint(claims["sub"].(float64))

	imageId := c.Query("id")
	if imageId == "" {
		return errorHandler.BadRequest(c)
	}
	//find
	var imageName string
	err := database.DB.QueryRow("SELECT link FROM images WHERE imageId = ? AND sellerId = ?", imageId, userId).Scan(&imageName)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	//delete
	_, err = database.DB.Exec("DELETE FROM images WHERE imageId = ? AND sellerId = ?", imageId, userId)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	//delete image from folder

	fileName := "./images/" + imageName
	err = os.Remove(fileName)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("Seller | Image deleted successfully by", userId)

	return c.JSON(fiber.Map{
		"message": "Image deleted successfully",
	})

}

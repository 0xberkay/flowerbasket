package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/api/helpers/stringHelper"
	"ciceksepeti/database"
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Upload uploads image to folder and database
func Upload(c *fiber.Ctx) error {

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userId := uint(claims["sub"].(float64))

	//upload product image
	file, err := c.FormFile("image")
	if err != nil {
		return errorHandler.Default(c, err)
	}

	// //if file is not an image
	// if file.Header["Content-Type"][0] != "image/png" && file.Header["Content-Type"][0] != "image/jpg" && file.Header["Content-Type"][0] != "image/jpeg" {
	// 	return errorHandler.BadRequest(c)
	// }

	if file.Size > 2*1024*1024 {
		return errorHandler.BigFile(c)
	}

	if len(file.Filename) > 200 || file.Filename == "" {
		return errorHandler.BadRequest(c)
	}

	rnd := stringHelper.RandStringBytesMaskImprSrcSB(6)
	file.Filename = fmt.Sprintf("%d%s-%s", userId, rnd, file.Filename)

	err = c.SaveFile(file, "./images/"+file.Filename)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	//upload image to images table to-do
	_, err = database.DB.Exec("INSERT INTO images (sellerId,link) VALUES (?, ?)", userId, file.Filename)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("Seller | Image uploaded successfully by", userId)

	return c.JSON(fiber.Map{
		"message": "Image uploaded successfully",
	})

}

package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// AddMessage adds address to user
func AddAddress(c *fiber.Ctx) error {
	// Parse the request body and extract the address values
	var address models.Address
	if err := c.BodyParser(&address); err != nil {
		return errorHandler.BadRequest(c)
	}
	//fmt.Println("address", address)
	// Validate the address values
	err := models.Validate.Struct(address)
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

	userId := uint(claims["sub"].(float64))

	// Insert the address into the database
	_, err = database.DB.Exec("INSERT INTO address (userId, street, city, state, zipCode, detail, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
		userId, address.Street, address.City, address.State, address.ZipCode, address.Detail, address.Latitude, address.Longitude)
	if err != nil {
		//fmt.Println(err)
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | Address added successfully by", userId)

	// Return a success response
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Address added successfully",
	})
}

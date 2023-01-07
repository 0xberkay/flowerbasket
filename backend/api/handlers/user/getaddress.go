package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// GetAddresses retrieves the user's addresses
func GetAddresses(c *fiber.Ctx) error {
	// Retrieve the user's ID from the JWT
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	// Retrieve the user's addresses from the database
	rows, err := database.DB.Query("SELECT addressId, street, city, state, zipCode, detail, latitude, longitude FROM address WHERE userId = ? and show = 1", userID)
	if err != nil {
		//fmt.Println("error", err.Error())
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var addresses []models.Address
	for rows.Next() {
		var address models.Address
		if err := rows.Scan(&address.AddressID, &address.Street, &address.City, &address.State, &address.ZipCode, &address.Detail, &address.Latitude, &address.Longitude); err != nil {
			//fmt.Println("error", err.Error())

			return errorHandler.InternalServerError(c)
		}
		addresses = append(addresses, address)
	}

	go database.Lof.Println("User | addresses retrieved successfully", userID)

	// Return the addresses in the response
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"addresses": addresses,
	})
}

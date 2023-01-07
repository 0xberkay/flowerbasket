package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// DeleteAddress deletes user's address
func DeleteAddress(c *fiber.Ctx) error {
	// Parse the request parameters and extract the address Id
	addressID := c.Query("id")

	// Retrieve the user's ID from the JWT
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	// Check if the address belongs to the user
	var dbAddress models.Address
	rows, err := database.DB.Query("SELECT userId FROM address WHERE addressId = ?", addressID)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&dbAddress.AddressID); err != nil {
			return errorHandler.InternalServerError(c)
		}
	}

	if uint(dbAddress.AddressID) != userID {
		return errorHandler.UnauthorizedDef(c)
	}

	// Delete the address from the database set show = 0
	_, err = database.DB.Exec("UPDATE address SET show = 0 WHERE addressId = ?", addressID)
	if err != nil {
		//fmt.Println("error", err.Error())
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | Address deleted successfully", addressID)

	// Return a success response
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Address deleted successfully",
	})
}

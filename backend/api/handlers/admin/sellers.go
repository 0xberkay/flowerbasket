package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Orders returns all orders
func Sellers(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Sellers")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var sellers []models.SellersAdmin

	for rows.Next() {
		var seller models.SellersAdmin
		err := rows.Scan(&seller.SellerId, &seller.Company, &seller.Password, &seller.Email, &seller.Point, &seller.Phone, &seller.Trust, &seller.Code)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		sellers = append(sellers, seller)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"sellers": sellers,
	})
}

package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/api/helpers/mailsender"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
)

// UpdateSeller updates seller's trust
func UpdateSeller(c *fiber.Ctx) error {
	query := c.Query("sellerId")

	show := c.Query("trust")

	if show == "0" {
		_, err := database.DB.Exec("UPDATE Sellers SET trust = 0 WHERE SellerId = ?", query)
		if err != nil {
			return errorHandler.InternalServerError(c)
		}
	} else if show == "1" {
		_, err := database.DB.Exec("UPDATE Sellers SET trust = 1 WHERE SellerId = ?", query)
		go mailsender.SendSellerConfirm(query)

		if err != nil {
			return errorHandler.InternalServerError(c)
		}
	} else {
		return errorHandler.BadRequest(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Seller updated successfully",
	})
}

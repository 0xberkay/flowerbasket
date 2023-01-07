package all

import (
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// StatusCodes returns all status codes
func StatusCodes(c *fiber.Ctx) error {
	rows, err := database.DB.Query("EXEC SelectAllStatusCodes")
	if err != nil {
		return err
	}

	var statusCodes []models.StatuCode

	for rows.Next() {
		var statuCode models.StatuCode
		err = rows.Scan(&statuCode.StatuID, &statuCode.StatuName)
		if err != nil {
			return err
		}
		statusCodes = append(statusCodes, statuCode)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"status_codes": statusCodes,
	})
}

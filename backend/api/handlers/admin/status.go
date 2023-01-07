package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Orders returns all orders
func Status(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM StatusCodes")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var status []models.StatuAdmin

	for rows.Next() {
		var statu models.StatuAdmin
		err := rows.Scan(&statu.StatuId, &statu.StatuName)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		status = append(status, statu)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"status": status,
	})
}

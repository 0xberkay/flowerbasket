package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Users returns all users
func Users(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM users")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var users []models.UserAdmin

	for rows.Next() {
		var user models.UserAdmin
		err := rows.Scan(&user.UserId, &user.UserName, &user.Email, &user.Password, &user.Code)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		users = append(users, user)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"users": users,
	})
}

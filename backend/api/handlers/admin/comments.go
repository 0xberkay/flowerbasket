package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Categories returns all categories
func Comments(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT * FROM Comments")
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var comments []models.CommentAdmin
	for rows.Next() {
		var comment models.CommentAdmin
		err := rows.Scan(&comment.CommentId, &comment.ProductId, &comment.UserId, &comment.Point, &comment.Comment, &comment.OrderId)
		if err != nil {
			//fmt.Println("Error while scanning users", err.Error())
			return errorHandler.InternalServerError(c)
		}
		comments = append(comments, comment)
	}
	if err = rows.Err(); err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"comments": comments,
	})
}

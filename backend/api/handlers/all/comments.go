package all

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
)

// Comments returns selected product's comments
func Comments(c *fiber.Ctx) error {
	query := c.Query("p")

	rows, err := database.DB.Query("EXEC CommentsConfirmed @id = ?", query)
	if err != nil {
		//fmt.Println("error", err.Error())
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var comments []models.CommentReturn
	for rows.Next() {
		var comment models.CommentReturn
		if err := rows.Scan(&comment.Username, &comment.Comment, &comment.Point); err != nil {
			//fmt.Println("error", err.Error())

			return errorHandler.InternalServerError(c)
		}
		comments = append(comments, comment)

	}

	go database.Lof.Println("Comments | comments retrieved successfully", query)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"comments": comments,
	})
}

package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"fmt"

	"github.com/gofiber/fiber/v2"
)

// AlterComment updates the comment stored procedure
func AlterComments(c *fiber.Ctx) error {

	_, err := database.DB.Exec(`
ALTER PROCEDURE [dbo].[CommentsConfirmed] @id INT
AS
BEGIN
    SELECT u.username,c.comment,c.point FROM comments c 
	JOIN Users u ON c.userId = u.userId 
    WHERE c.productId = @id
END
	`)
	if err != nil {
		fmt.Println("Error: ", err)
		return errorHandler.InternalServerError(c)
	}

	return c.JSON(fiber.Map{
		"message": "Comments updated",
	})
}

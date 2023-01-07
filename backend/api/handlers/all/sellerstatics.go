package all

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
)

// SellerStatics returns seller's statics
func SellerStatics(c *fiber.Ctx) error {

	var count int
	var maxPoint float32
	quey := c.Query("c")
	err := database.DB.QueryRow(`
	SELECT MAX(S.point),COUNT(productId) FROM Sellers s
	JOIN Products P ON S.sellerId = P.sellerId
	GROUP BY S.SellerID
	HAVING S.sellerId = ?
	`, quey).Scan(&maxPoint, &count)
	if err != nil {
		//fmt.Println("Error: ", err.Error())
		return errorHandler.InternalServerError(c)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"count":    count,
		"maxPoint": maxPoint,
	})
}

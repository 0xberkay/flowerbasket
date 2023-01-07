package seller

import (
	"ciceksepeti/api/helpers/mailsender"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// UpdateOrder updates the status of an order
func UpdateOrder(c *fiber.Ctx) error {
	// Parse the request body to get the new statuId value

	// Extract the orderId from the URL parameters
	orderID := c.Query("orderId")
	statuID := c.Query("statuId")

	// Retrieve the user's JWT token from the request context
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	// Extract the sellerId from the token claims
	sellerID := uint(claims["sub"].(float64))

	// Update the statuId for the order with the specified orderId
	_, err := database.DB.Exec(`
	UPDATE o
	SET o.statuId = ?
	FROM orders o
	INNER JOIN Products p ON o.productId = p.productId
	INNER JOIN Sellers s ON p.sellerId = s.sellerId
	WHERE orderId = ? AND s.sellerId = ?;
	`, statuID, orderID, sellerID)
	if err != nil {
		return err
	}

	go mailsender.SendNotification(orderID)
	go database.Lof.Println("Seller | Order updated successfully by", sellerID)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Order updated successfully",
	})
}

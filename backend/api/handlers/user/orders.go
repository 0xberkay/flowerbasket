package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/api/helpers/mailsender"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Orders returns user orders
func Orders(c *fiber.Ctx) error {
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	rows, err := database.DB.Query(`
	SELECT o.*,c.[message],p.productName,p.price,i.link,s.statuName FROM orders o 
	JOIN Products p ON p.productId = o.productId
	JOIN Images i ON i.imageId = p.imageId
	JOIN CartMessages c ON c.messageId = o.messageId 
	JOIN StatusCodes s ON s.statuId = o.statuId
    WHERE userId = ?
    ORDER BY o.messageId DESC`, userID)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()
	var orders []models.Order
	for rows.Next() {
		var order models.Order
		if err := rows.Scan(&order.OrderID, &order.UserID, &order.ProductID, &order.ProductCount, &order.StatuID, &order.AddressID, &order.CreatedAt, &order.MessageID, &order.Message, &order.ProductName, &order.Price, &order.Link, &order.StatuName); err != nil {
			//fmt.Println("Error while scanning orders: ", err.Error())
			return errorHandler.InternalServerError(c)

		}
		order.Link = c.BaseURL() + "/images/" + order.Link
		go func() {
			//select seller email
			var sellerEmail string
			err := database.DB.QueryRow(`
			SELECT s.email FROM Sellers s
			JOIN Products p ON p.sellerId = s.sellerId
			WHERE p.productId = ?`, order.ProductID).Scan(&sellerEmail)
			if err != nil {
				database.Lof.Println("Error while selecting seller email: ", err.Error())
			}
			mailsender.SendNotificationToSeller(order.ProductName, order.ProductCount, sellerEmail)
		}()
		orders = append(orders, order)
	}

	go database.Lof.Println("User | ", userID, "orders fetched successfully")

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"orders": orders,
	})
}

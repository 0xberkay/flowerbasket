package seller

import (
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Orders returns orders of seller
func Orders(c *fiber.Ctx) error {

	//claims
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	//id
	sellerID := uint(claims["sub"].(float64))

	//get orders
	rows, err := database.DB.Query(`
	SELECT Orders.*, Products.sellerId,StatusCodes.statuName,Address.street,
Address.city,Address.state,Address.zipCode,Address.detail,Address.latitude,Address.longitude,CartMessages.message,CartMessages.nameInMessage,Products.productName,Products.price
	FROM Orders
	JOIN Products ON Orders.productId = Products.productId
	JOIN StatusCodes ON Orders.statuId = StatusCodes.statuId
    JOIN Address ON Orders.addressId = Address.addressId
	JOIN CartMessages ON Orders.messageId = CartMessages.messageId
    Where Products.sellerId = ?
	`, sellerID)

	if err != nil {
		return err
	}

	orders := []models.OrderDetail{}

	for rows.Next() {
		var order models.OrderDetail
		err := rows.Scan(&order.OrderID, &order.UserID, &order.ProductID, &order.ProductCount, &order.StatuID, &order.AddressID, &order.CreatedAt, &order.MessageID, &order.SellerID, &order.StatuName, &order.Street, &order.City, &order.State, &order.ZipCode, &order.Detail, &order.Latitude, &order.Longitude, &order.Message, &order.NameInMessage, &order.ProductName, &order.Price)
		if err != nil {
			return err
		}
		orders = append(orders, order)
	}

	go database.Lof.Println("Seller | Orders fetched successfully by", sellerID)
	//return orders
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"seller_orders": orders,
	})
}

package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// GetCart gets cart of user
func GetCart(c *fiber.Ctx) error {
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userId := uint(claims["sub"].(float64))

	//query for cart
	rows, err := database.DB.Query(`
	SELECT c.cartId, c.productId, c.count, c.price, c.messageId ,m.[message],m.nameInMessage, i.link,p.productName
	FROM carts c
	JOIN Products p ON c.productId = p.productId
	LEFT JOIN CartMessages m ON c.messageId = m.messageId 
	LEFT JOIN Images i ON p.imageId = i.imageId
	WHERE userId = ?
	`, userId)
	if err != nil {
		//fmt.Println("error", err)
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var products []models.ProductInCart
	var totalProductPrice float32

	for rows.Next() {
		var product models.ProductInCart

		err = rows.Scan(&product.CartID, &product.ProductID, &product.Count, &product.Price, &product.MessageID, &product.Message, &product.NameInMessage, &product.Link, &product.Name)
		if err != nil {
			//fmt.Println("error", err)

			return errorHandler.InternalServerError(c)
		}
		product.Link = c.BaseURL() + "/images/" + product.Link
		totalProductPrice = product.Price + totalProductPrice
		products = append(products, product)
	}

	go database.Lof.Println("User | ", userId, "cart fetched successfully")

	return c.JSON(fiber.Map{
		"products": products,
		"total":    totalProductPrice,
	})
}

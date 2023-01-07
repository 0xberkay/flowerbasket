package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// ]
func DeleteFromCart(c *fiber.Ctx) error {
	//get id
	id := c.Query("id")

	if id == "" {
		return errorHandler.BadRequest(c)
	}

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userId := uint(claims["sub"].(float64))

	//query for cart
	rows, err := database.DB.Query("SELECT productId, count FROM carts WHERE productId = ? AND userId = ?", id, userId)
	if err != nil {
		//fmt.Println("error", err.Error())
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var productId int
	var count int

	for rows.Next() {
		err = rows.Scan(&productId, &count)
		if err != nil {
			//fmt.Println("error", err.Error())
			return errorHandler.InternalServerError(c)
		}
	}

	if productId == 0 {
		return errorHandler.ProductIsNotInCart(c)
	}

	//update cart
	_, err = database.DB.Exec("DELETE FROM carts WHERE productId = ? AND userId = ?", id, userId)
	if err != nil {
		//fmt.Println("error", err.Error())
		return errorHandler.InternalServerError(c)
	}

	//update stock
	_, err = database.DB.Exec("UPDATE products SET stock = stock + ? WHERE productId = ?", count, id)
	if err != nil {
		//fmt.Println("error", err.Error())
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | ", userId, " | deleted product from cart | ", id)

	return c.JSON(fiber.Map{
		"message": "Product deleted from cart",
	})
}

package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// UpdateCart updates cart count of product in cart
func UpdateCart(c *fiber.Ctx) error {

	id := c.Query("id")
	count := c.Query("count")

	if id == "" || count == "" {
		return errorHandler.BadRequest(c)
	}

	//user id
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userID := uint(claims["sub"].(float64))

	//get old count from cart
	rows, err := database.DB.Query("SELECT count FROM carts WHERE productId = ? AND userId = ?", id, userID)
	if err != nil {
		//fmt.Println("error", err)
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var oldCount int

	for rows.Next() {
		err = rows.Scan(&oldCount)
		if err != nil {
			//fmt.Println("error", err)
			return errorHandler.InternalServerError(c)
		}
	}

	if oldCount == 0 {
		return errorHandler.BadRequest(c)
	}

	//get stock	& price from products
	rows, err = database.DB.Query("SELECT stock,price FROM products WHERE productId = ?", id)

	if err != nil {
		//fmt.Println("error", err)
		return errorHandler.InternalServerError(c)
	}

	var stock int
	var price float32

	for rows.Next() {
		err = rows.Scan(&stock, &price)
		if err != nil {
			//fmt.Println("error", err)
			return errorHandler.InternalServerError(c)
		}
	}

	newCount, err := strconv.Atoi(count)
	if err != nil {
		return errorHandler.BadRequest(c)
	}

	//check stock
	if stock == 0 && newCount > 0 || newCount > stock {
		return errorHandler.ProductIsOutOfStock(c)
	}

	//update cart
	newCount = newCount + oldCount
	newPrice := price * float32(newCount)

	if newCount == 0 {
		DeleteFromCart(c)
	} else if newCount < 0 {
		return errorHandler.BadRequest(c)
	}

	_, err = database.DB.Exec("UPDATE carts SET count = ?, price = ? WHERE productId = ? AND userId = ?", newCount, newPrice, id, userID)
	if err != nil {
		//fmt.Println("error", err)
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | ", userID, " | updated cart")

	return c.JSON(fiber.Map{
		"message": "success",
	})
}

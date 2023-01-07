package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// AddToCart adds product to cart
func AddToCart(c *fiber.Ctx) error {
	//get id
	id := c.Query("id")

	if id == "" {
		return errorHandler.BadRequest(c)
	}

	//query for stocks
	rows, err := database.DB.Query("SELECT stock,price FROM products WHERE productId = ?", id)
	if err != nil {

		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var stock int
	var priceDB float32

	for rows.Next() {
		err = rows.Scan(&stock, &priceDB)
		if err != nil {
			//fmt.Println("error", err)
			return errorHandler.InternalServerError(c)
		}
	}

	if stock == 0 {
		return errorHandler.ProductIsOutOfStock(c)
	}

	count := c.Query("count")
	if count == "" {
		return errorHandler.BadRequest(c)
	}

	countInt, _ := strconv.Atoi(count)

	if countInt > stock || countInt < 1 {
		return errorHandler.ProductIsOutOfStock(c)
	}

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userId := uint(claims["sub"].(float64))

	//query for cart
	rows, err = database.DB.Query("SELECT productId FROM carts WHERE productId = ? AND userId = ?", id, userId)
	if err != nil {
		//fmt.Println("error", err)
		return errorHandler.InternalServerError(c)
	}
	defer rows.Close()

	var productId int

	for rows.Next() {
		err = rows.Scan(&productId)
		if err != nil {
			//fmt.Println("error", err)
			return errorHandler.InternalServerError(c)
		}
	}

	price := priceDB * float32(countInt)

	if productId == 0 {

		_, err = database.DB.Exec("INSERT INTO carts (productId, userId, price, count) VALUES (?, ?, ?, ?)", id, userId, price, countInt)
		if err != nil {
			//fmt.Println("error", err)
			return errorHandler.InternalServerError(c)
		}
	} else {
		//update cart
		_, err = database.DB.Exec("UPDATE carts SET count = count + ? ,price = price + ? WHERE productId = ? AND userId = ?", countInt, priceDB, id, userId)
		if err != nil {
			return errorHandler.InternalServerError(c)
		}
	}

	go database.Lof.Println("User | Product added to cart by", userId)

	return c.JSON(fiber.Map{
		"message": "Product added to cart",
	})
}

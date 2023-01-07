package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"strconv"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// BuyCart buys products in cart
func BuyCart(c *fiber.Ctx) error {
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userId := uint(claims["sub"].(float64))

	adressId := c.Query("adressId")

	if adressId == "" {
		return errorHandler.BadRequest(c)
	}

	//check adress
	var adressIdInt int
	err := database.DB.QueryRow("SELECT addressId FROM Address WHERE addressId = ? AND userId = ?", adressId, userId).Scan(&adressIdInt)
	if err != nil {
		return errorHandler.UnauthorizedDef(c)
	}

	//get cart
	rows, err := database.DB.Query("SELECT productId,count,messageId FROM carts WHERE userId = ?", userId)
	if err != nil {
		//fmt.Println("error", err)
		return errorHandler.InternalServerError(c)
	}

	var productIdList []int
	var countList []int
	var messageList []int

	for rows.Next() {
		var productId int
		var count int
		var messageId int
		err = rows.Scan(&productId, &count, &messageId)
		if err != nil {
			//fmt.Println("error", err)

			return errorHandler.InternalServerError(c)
		}

		productIdList = append(productIdList, productId)
		countList = append(countList, count)
		messageList = append(messageList, messageId)
	}

	if len(productIdList) == 0 {
		return errorHandler.BadRequest(c)
	}

	//insert into orders
	insertQuery := "INSERT INTO orders (userId,productId,addressId,productCount,messageId) VALUES "
	for i := 0; i < len(productIdList); i++ {
		insertQuery += "(" + strconv.Itoa(int(userId)) + "," + strconv.Itoa(productIdList[i]) + "," + adressId + "," + strconv.Itoa(countList[i]) + "," + strconv.Itoa(messageList[i]) + ")"
		if i != len(productIdList)-1 {
			insertQuery += ","
		}

	}

	_, err = database.DB.Exec(insertQuery)
	if err != nil {
		//fmt.Println("error1", err)

		return errorHandler.InternalServerError(c)
	}

	//delete from cart
	_, err = database.DB.Exec("DELETE FROM carts WHERE userId = ?", userId)
	if err != nil {
		//fmt.Println("error", err)

		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | bought cart", userId)

	return c.JSON(fiber.Map{
		"message": "success",
	})
}

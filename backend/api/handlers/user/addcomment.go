package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"strconv"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// AddComment adds comment to order
func AddComment(c *fiber.Ctx) error {

	orderId := c.Query("orderId")
	if orderId == "" {
		return errorHandler.RequiredField(c, "orderId")
	}

	point := c.Query("point")
	pointInt, err := strconv.Atoi(point)
	if err != nil {
		return errorHandler.RequiredField(c, "point")
	}
	//fmt.Println(pointInt)

	if pointInt < 1 || pointInt > 5 {
		return errorHandler.BadRequest(c)
	}

	// Parse the request body and extract the comment values
	var comment models.Comment
	if err := c.BodyParser(&comment); err != nil {
		return errorHandler.BadRequest(c)
	}

	// Validate the comment values
	err = models.Validate.Struct(comment)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" {
				return errorHandler.RequiredField(c, err.Field())
			}
			if err.Tag() == "min" {
				return errorHandler.MinLength(c, err.Field(), err.Param())
			}
			if err.Tag() == "max" {
				return errorHandler.MaxLength(c, err.Field(), err.Param())
			}
		}
	}

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)
	userId := uint(claims["sub"].(float64))

	//check if status is was delivered
	row := database.DB.QueryRow("SELECT statuId,productId FROM orders WHERE orderId = ? AND userId = ?", orderId, userId)
	var statuId uint
	var productId uint
	err = row.Scan(&statuId, &productId)
	if err != nil {
		return errorHandler.NotFoundProduct(c)
	}

	if statuId != 4 {
		//fmt.Println(statuId)
		return errorHandler.BadRequest(c)
	}

	// Insert the comment into the database
	_, err = database.DB.Exec("INSERT INTO comments (userId,productId,point,comment,orderId) VALUES (?,?, ?, ?, ?)", userId, productId, point, comment.Comment, orderId)
	if err != nil {
		//fmt.Println("Error: ", err.Error())
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("Comment added successfully |", c.Locals("user"))

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Comment added successfully",
	})
}

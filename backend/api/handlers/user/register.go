package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"context"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"golang.org/x/crypto/bcrypt"
)

// Register registers user
func Register(c *fiber.Ctx) error {
	var user models.User

	if err := c.BodyParser(&user); err != nil {
		return errorHandler.BadRequest(c)
	}

	err := models.Validate.Struct(user)
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
			if err.Tag() == "email" {
				return errorHandler.EmailIsNotValid(c)
			}
			if err.Tag() == "eqfield" {
				return errorHandler.PasswordsDoNotMatch(c)
			}
		}
	}

	//check if user already exists
	rows, err := database.DB.QueryContext(context.TODO(), "SELECT username,email FROM users WHERE username = ? OR email = ?", user.Username, user.Email)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	defer rows.Close()
	for rows.Next() {
		var username, email string
		if err := rows.Scan(&username, &email); err != nil {
			return errorHandler.InternalServerError(c)
		}
		if username == user.Username {
			return errorHandler.AlreadyExists(c, "username")
		}
		if email == user.Email {
			return errorHandler.AlreadyExists(c, "email")

		}
	}

	bytPass, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	user.Password = string(bytPass)

	sqlStatement := `
	INSERT INTO Users (username,email,password)
	VALUES ($1, $2, $3)
	`
	_, err = database.DB.ExecContext(context.Background(), sqlStatement, user.Username, user.Email, user.Password)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | ", user.Username, " | registered")

	return c.JSON(fiber.Map{
		"message": "success",
	})

}

package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"fmt"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
)

// Login logs in user and returns token
func Login(c *fiber.Ctx) error {
	var user models.UserLogin

	if err := c.BodyParser(&user); err != nil {
		return errorHandler.BadRequest(c)
	}

	err := models.Validate.Struct(user)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" {
				return errorHandler.RequiredField(c, err.Field())

			}
			if err.Tag() == "min" || err.Tag() == "max" {
				return errorHandler.WrongPassword(c)
			}

			if err.Tag() == "email" {
				return errorHandler.EmailIsNotValid(c)
			}
		}
	}

	//find user
	var dbUser models.User
	rows, err := database.DB.Query("SELECT userId,username,email,password FROM users WHERE email = ?", user.Email)
	if err != nil {
		fmt.Println("Error while scanning rows: ", err.Error())

		return errorHandler.InternalServerError(c)

	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&dbUser.ID, &dbUser.Username, &dbUser.Email, &dbUser.Password); err != nil {
			fmt.Println("Error while scanning rows: ", err.Error())
			return errorHandler.InternalServerError(c)
		}
	}

	if dbUser.ID == 0 || dbUser.Email != user.Email {
		return errorHandler.NotFoundUser(c)
	}

	if err := bcrypt.CompareHashAndPassword([]byte(dbUser.Password), []byte(user.Password)); err != nil {
		return errorHandler.WrongPassword(c)
	}

	claims := jwt.MapClaims{
		"sub":      dbUser.ID,
		"username": dbUser.Username,
		"email":    dbUser.Email,
		"exp":      time.Now().Add(time.Hour * 24).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString(database.Secret)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | ", dbUser.ID, "logged in successfully")

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": t,
	})
}

package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
)

// ChangePass changes user password and updates it in db with code = null
func ChangePass(c *fiber.Ctx) error {
	//change password
	var user models.PasswordReset

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

			if err.Tag() == "eqfield" {
				return errorHandler.PasswordsDoNotMatch(c)
			}
		}
	}

	//password hashing
	bytPass, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	user.Password = string(bytPass)

	//update password in db
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	//update password and code in db
	_, err = database.DB.Exec("UPDATE users SET code = NULL ,password = ? WHERE userId = ?", user.Password, uint(claims["sub"].(float64)))
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("User | Password changed successfully by", uint(claims["sub"].(float64)))

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Password changed successfully",
	})

}

package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/api/helpers/mailsender"
	"ciceksepeti/api/helpers/stringHelper"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"context"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
)

// ForgetPass sends code to user's email
func ForgetPass(c *fiber.Ctx) error {
	var email models.Email

	if err := c.BodyParser(&email); err != nil {
		return errorHandler.BadRequest(c)
	}
	err := models.Validate.Struct(email)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" {
				return errorHandler.RequiredField(c, err.Field())
			}
			if err.Tag() == "email" {
				return errorHandler.EmailIsNotValid(c)
			}
		}
	}

	//find user in database
	//if user not found return error
	var dbUseremail, username string
	rows := database.DB.QueryRow("SELECT email,username FROM users WHERE email = ?", email.Email)

	rows.Scan(&dbUseremail, &username)

	if dbUseremail != email.Email {
		return errorHandler.NotFoundEmail(c)
	}

	//generate token and update database
	code := stringHelper.RandStringBytesMaskImprSrcSB(20)
	_, err = database.DB.ExecContext(context.Background(), "UPDATE users SET code = ? WHERE email = ?", code, email.Email)
	if err != nil {
		return errorHandler.InternalServerError(c)

	}

	//send email
	go mailsender.SendCode(email.Email, username, code, "user", c.BaseURL())

	go database.Lof.Println("User | ", username, "Forget password code sent to", email.Email)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "ok",
	})
}

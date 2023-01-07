package seller

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

// ForgetPass sends code to seller's email
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
	var dbUseremail, company string
	rows := database.DB.QueryRow("SELECT email,company FROM sellers WHERE email = ?", email.Email)

	rows.Scan(&dbUseremail, &company)

	if dbUseremail != email.Email {
		return errorHandler.NotFoundEmail(c)
	}

	//generate token and update database
	code := stringHelper.RandStringBytesMaskImprSrcSB(20)
	_, err = database.DB.ExecContext(context.Background(), "UPDATE sellers SET code = ? WHERE email = ?", code, email.Email)
	if err != nil {
		return errorHandler.InternalServerError(c)

	}

	//send email
	mailsender.SendCode(email.Email, company, code, "seller", c.BaseURL())

	go database.Lof.Println("Seller | Forget password code sent to", email.Email)

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "ok",
	})
}

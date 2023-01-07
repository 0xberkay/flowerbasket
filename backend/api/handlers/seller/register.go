package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"context"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"golang.org/x/crypto/bcrypt"
)

// Register registers seller
func Register(c *fiber.Ctx) error {
	var seller models.Seller

	if err := c.BodyParser(&seller); err != nil {
		return errorHandler.BadRequest(c)
	}

	err := models.Validate.Struct(seller)
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

	//check if seller already exists
	rows, err := database.DB.QueryContext(context.TODO(), "SELECT company,email,phone FROM sellers WHERE company = ? OR email = ? OR phone = ?", seller.Company, seller.Email, seller.Phone)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	defer rows.Close()
	for rows.Next() {
		var company, email, phone string
		if err := rows.Scan(&company, &email, &phone); err != nil {
			return errorHandler.InternalServerError(c)
		}
		if company == seller.Company {
			return errorHandler.AlreadyExists(c, "company")
		}
		if email == seller.Email {
			return errorHandler.AlreadyExists(c, "email")
		}
		if phone == seller.Phone {
			return errorHandler.AlreadyExists(c, "phone")
		}
	}

	bytPass, err := bcrypt.GenerateFromPassword([]byte(seller.Password), bcrypt.DefaultCost)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	seller.Password = string(bytPass)

	sqlStatement := `
	INSERT INTO Sellers (company,email,password,phone)
	VALUES ($1, $2, $3, $4)
	`
	_, err = database.DB.ExecContext(context.TODO(), sqlStatement, seller.Company, seller.Email, seller.Password, seller.Phone)
	if err != nil {
		//fmt.Println("err", err)
		return errorHandler.InternalServerError(c)
	}

	go database.Lof.Println("Seller | New seller registered", seller.Company)

	return c.JSON(fiber.Map{
		"message": "success",
	})

}

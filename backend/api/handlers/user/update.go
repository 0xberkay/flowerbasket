package user

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// Update updates user info and updates it in db
func Update(c *fiber.Ctx) error {
	var user models.User

	if err := c.BodyParser(&user); err != nil {
		return errorHandler.BadRequest(c)
	}

	if user.Username == "" && user.Email == "" {
		return errorHandler.NoChanges(c)
	}

	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	userClaims := models.User{
		ID:       uint(claims["sub"].(float64)),
		Username: claims["username"].(string),
		Email:    claims["email"].(string),
	}

	err := models.Validate.Struct(user)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			if err.Tag() == "required" && err.Field() == "Username" {
				user.Username = userClaims.Username
			}
			if err.Tag() == "required" && err.Field() == "Email" {
				user.Email = userClaims.Email
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
		}
	}

	// Update user
	_, err = database.DB.Exec("UPDATE users SET username = ?, email = ? WHERE userId = ?", user.Username, user.Email, userClaims.ID)
	if err != nil {
		//fmt.Println("Error: ", err.Error())
		return errorHandler.InternalServerError(c)

	}

	claims["username"] = user.Username
	claims["email"] = user.Email

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString(database.Secret)
	if err != nil {
		return errorHandler.InternalServerError(c)

	}

	go database.Lof.Println("User | ", userClaims.ID, "updated successfully")

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": t,
	})

}

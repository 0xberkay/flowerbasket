package seller

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"
	"ciceksepeti/models"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

// ConfirmCode confirms code render reset page with token
func ConfirmCode(c *fiber.Ctx) error {
	param := c.Query("code")
	// if len(param) != 20 {

	// 	return errorHandler.BadRequest(c)
	// }

	//query code from database
	rows := database.DB.QueryRow("SELECT sellerId,company,email FROM sellers WHERE code = ?", param)

	var dbUser models.Seller
	err := rows.Scan(&dbUser.ID, &dbUser.Company, &dbUser.Email)
	if err != nil {
		return errorHandler.BadRequest(c)
	}

	claims := jwt.MapClaims{
		"sub":     dbUser.ID,
		"company": dbUser.Company,
		"email":   dbUser.Email,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	t, err := token.SignedString(database.Secret2)
	if err != nil {
		return errorHandler.InternalServerError(c)

	}

	go database.Lof.Println("Seller | Code confirmed successfully by", dbUser.ID)

	return c.Render("reset", fiber.Map{
		"title": dbUser.Company,
		"type":  "seller",
		"token": t,
	})
}

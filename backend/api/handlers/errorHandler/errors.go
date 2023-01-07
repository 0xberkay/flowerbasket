package errorHandler

import (
	"ciceksepeti/database"
	"fmt"

	"github.com/gofiber/fiber/v2"
)

func Unauthorized(c *fiber.Ctx, err error) error {
	go database.Lof.Println("Error Unauthorized | ", err.Error(), c.Locals("user"))
	return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
		"message": "Unauthorized",
	})
}

func UnauthorizedDef(c *fiber.Ctx) error {
	go database.Lof.Println("Error Unauthorized |", c.Locals("user"))
	return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
		"message": "This does not belong to you",
	})
}

func BadRequest(c *fiber.Ctx) error {
	go database.Lof.Println("Error BadRequest |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "Bad Request",
	})
}

func InternalServerError(c *fiber.Ctx) error {
	go database.Lof.Println("Error InternalServerError |", c.Locals("user"))
	return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
		"message": "Internal Server Error",
	})
}

func EmailIsNotValid(c *fiber.Ctx) error {
	go database.Lof.Println("Error EmailIsNotValid |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "email is not valid",
	})
}

func PasswordsDoNotMatch(c *fiber.Ctx) error {
	go database.Lof.Println("Error PasswordsDoNotMatch |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "passwords do not match",
	})
}

func RequiredField(c *fiber.Ctx, field string) error {
	go database.Lof.Println("Error RequiredField |", field, c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": fmt.Sprintf("%s is required", field),
	})
}

func MinLength(c *fiber.Ctx, field string, length string) error {
	go database.Lof.Println("Error MinLength |", field, length, c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": fmt.Sprintf("%s must be at least %s characters long", field, length),
	})
}

func MaxLength(c *fiber.Ctx, field string, length string) error {
	go database.Lof.Println("Error MaxLength |", field, length, c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": fmt.Sprintf("%s must be at most %s characters long", field, length),
	})
}

func AlreadyExists(c *fiber.Ctx, field string) error {
	go database.Lof.Println("Error AlreadyExists |", field, c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": fmt.Sprintf("%s already exists", field),
	})
}

func NoChanges(c *fiber.Ctx) error {
	go database.Lof.Println("Error NoChanges |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "no changes were made",
	})
}

func WrongPassword(c *fiber.Ctx) error {
	go database.Lof.Println("Error WrongPassword |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "wrong password",
	})
}

func NotFoundEmail(c *fiber.Ctx) error {
	go database.Lof.Println("Error NotFoundEmail |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "There is no user with this email",
	})
}

func NotFoundUser(c *fiber.Ctx) error {
	go database.Lof.Println("Error NotFoundUser |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "User not found",
	})
}

func NotFoundProduct(c *fiber.Ctx) error {
	go database.Lof.Println("Error NotFoundProduct |", c.Locals("user"))
	return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
		"message": "Product not found",
	})
}

func BigFile(c *fiber.Ctx) error {
	go database.Lof.Println("Error BigFile |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "file size is too big",
	})
}

func ProductIsOutOfStock(c *fiber.Ctx) error {
	go database.Lof.Println("Error ProductIsOutOfStock |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "product is out of stock",
	})
}

func ProductIsNotInCart(c *fiber.Ctx) error {
	go database.Lof.Println("Error ProductIsNotInCart |", c.Locals("user"))
	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"message": "product is not in cart",
	})
}

func Default(c *fiber.Ctx, err error) error {
	go database.Lof.Println("Error Default |", err, c.Locals("user"))
	return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
		"message": err.Error(),
	})
}

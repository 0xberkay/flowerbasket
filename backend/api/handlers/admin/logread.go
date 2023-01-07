package admin

import (
	"bufio"
	"ciceksepeti/api/handlers/errorHandler"
	"fmt"
	"os"

	"github.com/gofiber/fiber/v2"
)

// LogRead returns last 10 lines of log file
func LogRead(c *fiber.Ctx) error {

	query := c.Query("query")
	var stringQuery string
	if query == "1" {
		stringQuery = "api"
	} else if query == "2" {
		stringQuery = "handler"
	} else {
		return errorHandler.BadRequest(c)
	}
	file, err := os.Open(fmt.Sprintf("./log/%s.log", stringQuery))
	if err != nil {

		return errorHandler.InternalServerError(c)
	}
	defer file.Close()

	// Create a buffer to store the lines
	lines := make([]string, 0)

	// Read the file line by line
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	// Check for errors
	if err := scanner.Err(); err != nil {

		return errorHandler.InternalServerError(c)
	}

	// Get the last 10 lines
	start := len(lines) - 10
	if start < 0 {
		start = 0
	}
	last10Lines := lines[start:]

	// Send the last 10 lines to the client
	return c.JSON(last10Lines)
}

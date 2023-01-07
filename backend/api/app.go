package api

import (
	"ciceksepeti/api/routes"
	"log"
	"os"

	"github.com/goccy/go-json"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/template/html"
)

func Api() {

	engine := html.New("./views", ".html")

	app := fiber.New(fiber.Config{
		AppName:     "CicekSepeti",
		Views:       engine,
		Prefork:     true,
		JSONEncoder: json.Marshal,
		JSONDecoder: json.Unmarshal,
	})

	file, err := os.OpenFile("./log/api.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}
	defer file.Close()

	app.Use(logger.New(logger.Config{
		Output: file,
		Format: "${time} ${status} -${method} ${path} ${latency}\n",
	}))

	routes.Setup(app)
	app.Use(cors.New(cors.Config{
		AllowHeaders:     "Origin, Content-Type, Accept, Authorization",
		AllowMethods:     "GET, POST",
		AllowCredentials: true,
		AllowOrigins:     "*",
	}))
	app.Listen(":3000")
}

package routes

import (
	"ciceksepeti/api/handlers/admin"
	"ciceksepeti/api/handlers/all"
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/api/handlers/seller"
	"ciceksepeti/api/handlers/user"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/basicauth"
	jwtware "github.com/gofiber/jwt/v3"
)

func Setup(app *fiber.App) {

	app.Static("/images", "./images")

	app.Static("/ok", "./views/ok.html")

	allApp := app.Group("/all")

	allApp.Get("/products", all.GetAllProducts)
	allApp.Get("/company", all.CompanyProducts)
	allApp.Get("/sellerstatics", all.SellerStatics)
	allApp.Get("/comments", all.Comments)
	allApp.Get("/categories", all.Categories)
	allApp.Get("/selected", all.SelectedCategory)
	allApp.Get("/search", all.Search)
	allApp.Get("/statuscodes", all.StatusCodes)

	allApp.Get("/check", all.Check)

	userApp := app.Group("/user", jwtware.New(jwtware.Config{
		SigningKey: database.Secret,
		Filter: func(c *fiber.Ctx) bool {
			return c.Path() == "/user/login" || c.Path() == "/user/register" ||
				c.Path() == "/user/forget" || c.Path() == "/user/confirmcode"
		},
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			go database.Lof.Println("Middleware Error | ", err.Error(), c.IPs(), c.AllParams())
			return errorHandler.Unauthorized(c, err)
		},
	}))

	userApp.Post("/register", user.Register)
	userApp.Post("/login", user.Login)
	userApp.Post("/forget", user.ForgetPass)
	userApp.Get("/confirmcode", user.ConfirmCode)

	userApp.Get("/profile", user.Profile)
	userApp.Post("/changepass", user.ChangePass)
	userApp.Post("/update", user.Update)
	userApp.Post("/addaddress", user.AddAddress)
	userApp.Get("/deleteaddress", user.DeleteAddress)
	userApp.Get("/getaddresses", user.GetAddresses)
	userApp.Get("/addtocart", user.AddToCart)
	userApp.Get("/deletefromcart", user.DeleteFromCart)
	userApp.Get("/getcart", user.GetCart)
	userApp.Get("/updatecart", user.UpdateCart)
	userApp.Get("/buycart", user.BuyCart)
	userApp.Get("/orders", user.Orders)
	userApp.Post("/addmessage", user.AddMessage)
	userApp.Get("/getmessage", user.GetMessage)
	userApp.Post("/updatemessage", user.UpdateMessage)
	userApp.Get("/deletemessage", user.DeleteMessage)
	userApp.Post("/addcomment", user.AddComment)

	sellerApp := app.Group("/seller", jwtware.New(jwtware.Config{
		SigningKey: database.Secret2,
		Filter: func(c *fiber.Ctx) bool {
			return c.Path() == "/seller/login" || c.Path() == "/seller/register" ||
				c.Path() == "/seller/forget" || c.Path() == "/seller/confirmcode"
		},
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			go database.Lof.Println("Middleware Error | ", err.Error(), c.IPs(), c.AllParams(), c.Query("user"))
			return errorHandler.Unauthorized(c, err)
		},
	}))

	sellerApp.Post("/register", seller.Register)
	sellerApp.Post("/login", seller.Login)
	sellerApp.Post("/forget", seller.ForgetPass)
	sellerApp.Get("/confirmcode", seller.ConfirmCode)

	sellerApp.Get("/profile", seller.Profile)
	sellerApp.Post("/changepass", seller.ChangePass)
	sellerApp.Post("/update", seller.Update)
	sellerApp.Post("/addproduct", seller.AddProduct)
	sellerApp.Get("/getproduct", seller.GetProducts)
	sellerApp.Post("/updateproduct", seller.UpdateProduct)
	sellerApp.Post("/upload", seller.Upload)
	sellerApp.Get("/delete", seller.Delete)
	sellerApp.Get("/gallery", seller.GetGallery)
	sellerApp.Get("/orders", seller.Orders)
	sellerApp.Get("/updateorder", seller.UpdateOrder)
	sellerApp.Get("/ordersexcel", seller.OrdersExcel)
	sellerApp.Get("/orderscexcel", seller.OrdersExcelChart)

	adminApp := app.Group("/admin", basicauth.New(basicauth.Config{
		Users: map[string]string{
			"admin": "admin",
		},
		Unauthorized: func(c *fiber.Ctx) error {
			go database.Lof.Println("Middleware Error | ", c.IPs(), c.AllParams())
			return c.SendStatus(fiber.StatusUnauthorized)
		},
	}))

	adminApp.Get("/ok", func(c *fiber.Ctx) error {
		return c.SendStatus(fiber.StatusOK)
	})
	adminApp.Get("/users", admin.Users)
	adminApp.Get("/status", admin.Status)
	adminApp.Get("/sellers", admin.Sellers)
	adminApp.Get("/products", admin.Products)
	adminApp.Get("/orders", admin.Orders)
	adminApp.Get("/messages", admin.CartMessages)
	adminApp.Get("/comments", admin.Comments)
	adminApp.Get("/categories", admin.Categories)
	adminApp.Get("/images", admin.Images)
	adminApp.Get("/carts", admin.Carts)
	adminApp.Get("/updateseller", admin.UpdateSeller)
	adminApp.Get("/readlog", admin.LogRead)
	adminApp.Get("/alterproducts", admin.AlterProducts)
	adminApp.Get("/altercomments", admin.AlterComments)

}

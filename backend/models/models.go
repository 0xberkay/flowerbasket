package models

import (
	"time"

	"github.com/go-playground/validator/v10"
)

var Validate = validator.New()

type User struct {
	ID       uint
	Username string `json:"username" validate:"required,min=3,max=20"`
	Password string `json:"password" validate:"required,min=6,max=20"`
	Confirm  string `json:"confirm" validate:"required,eqfield=Password"`
	Email    string `json:"email" validate:"required,email"`
}

type CheckUser struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	IsSeller bool   `json:"is_seller"`
}

type UserLogin struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=6,max=20"`
}

type PasswordReset struct {
	Password string `json:"password" validate:"required,min=6,max=20"`
	Confirm  string `json:"confirm" validate:"required,eqfield=Password"`
}

type Email struct {
	Email string `json:"email" validate:"required,email"`
}

type Seller struct {
	ID       uint
	Company  string  `json:"company" validate:"required,min=3,max=20"`
	Password string  `json:"password" validate:"required,min=6,max=20"`
	Email    string  `json:"email" validate:"required,email"`
	Point    float32 `json:"point"`
	Phone    string  `json:"phone" validate:"required,min=10,max=15"`
	Confirm  string  `json:"confirm" validate:"required,eqfield=Password"`
	Trust    bool    `json:"trust"`
}

type Product struct {
	ID           uint
	Name         string    `json:"product_name" validate:"required,min=3,max=30"`
	SellerID     uint      `json:"seller_id"`
	Description  string    `json:"description" validate:"required,min=3,max=4000"`
	ImageID      uint      `json:"image_id" validate:"required"`
	ImageLink    string    `json:"image_link"`
	Price        float32   `json:"price" validate:"required"`
	Stock        uint      `json:"stock" validate:"required"`
	ProductPoint float32   `json:"product_point"`
	CategoryID   uint      `json:"category_id" validate:"required,min=1,max=100"`
	CreatedAt    time.Time `json:"created_at"`
	CategoryName string    `json:"category_name"`
}

type Image struct {
	ID   uint   `json:"id"`
	Link string `json:"link"`
}

type AllProduct struct {
	ID           uint    `json:"product_id"`
	Company      string  `json:"company"`
	SellerID     uint    `json:"seller_id"`
	ProductName  string  `json:"product_name"`
	Description  string  `json:"description"`
	Price        float32 `json:"price"`
	Stock        int     `json:"stock"`
	CategoryName string  `json:"category_name"`
	Link         string  `json:"link"`
	Point        float64 `json:"point"`
}

type Address struct {
	AddressID int
	Street    string  `json:"street" validate:"required,min=3,max=30"`
	City      string  `json:"city" validate:"required,min=3,max=30"`
	State     string  `json:"state" validate:"required,min=3,max=30"`
	ZipCode   string  `json:"zip_code" validate:"required,min=5,max=5"`
	Detail    string  `json:"detail" validate:"required,min=3,max=255"`
	Latitude  float64 `json:"latitude" validate:"required,latitude"`
	Longitude float64 `json:"longitude" validate:"required,longitude"`
}

type ProductInCart struct {
	CartID        uint    `json:"cart_id"`
	ProductID     uint    `json:"product_id"`
	Count         uint    `json:"count"`
	Price         float32 `json:"price"`
	NameInMessage string  `json:"name_in_message"`
	MessageID     uint    `json:"message_id"`
	Message       string  `json:"message"`
	Link          string  `json:"link"`
	Name          string  `json:"product_name"`
}

type Order struct {
	OrderID      uint      `json:"order_id"`
	UserID       uint      `json:"user_id"`
	ProductID    uint      `json:"product_id"`
	ProductCount uint      `json:"product_count"`
	StatuID      uint      `json:"statu_id"`
	StatuName    string    `json:"statu_name"`
	AddressID    uint      `json:"address_id"`
	CreatedAt    time.Time `json:"created_at"`
	SellerID     uint      `json:"seller_id"`
	MessageID    uint      `json:"message_id"`
	Message      string    `json:"message"`
	ProductName  string    `json:"product_name"`
	Price        float32   `json:"price"`
	Link         string    `json:"link"`
}

type OrderDetail struct {
	OrderID       uint      `json:"order_id"`
	UserID        uint      `json:"user_id"`
	ProductID     uint      `json:"product_id"`
	ProductName   string    `json:"product_name"`
	Price         float32   `json:"price"`
	ProductCount  uint      `json:"product_count"`
	StatuID       uint      `json:"statu_id"`
	AddressID     uint      `json:"address_id"`
	StatuName     string    `json:"statu_name"`
	CreatedAt     time.Time `json:"created_at"`
	MessageID     uint      `json:"message_id"`
	CartID        uint      `json:"cart_id"`
	Message       string    `json:"message"`
	NameInMessage string    `json:"name_in_message"`
	SellerID      uint      `json:"seller_id"`
	Street        string    `json:"street"`
	City          string    `json:"city"`
	State         string    `json:"state"`
	ZipCode       string    `json:"zip_code"`
	Detail        string    `json:"detail"`
	Latitude      float64   `json:"latitude"`
	Longitude     float64   `json:"longitude"`
}

type StatuCode struct {
	StatuID   uint   `json:"statu_id"`
	StatuName string `json:"statu_name"`
}

type CartMessage struct {
	MessageID uint
	CartID    uint   `json:"cart_id"`
	Message   string `json:"message" validate:"required,min=3"`
	Name      string `json:"name" validate:"required,min=3,max=50"`
}

type Comment struct {
	CommentID uint
	UserID    uint
	ProductID uint
	OrderID   uint
	Point     float32
	Comment   string `json:"comment" validate:"required,min=3,max=255"`
}

type CommentReturn struct {
	Username string  `json:"username"`
	Comment  string  `json:"comment"`
	Point    float32 `json:"point"`
}

type Category struct {
	CategoryID   uint   `json:"category_id"`
	CategoryName string `json:"category_name"`
}

type Error struct {
	Message string `json:"message"`
}

type Message struct {
	Message string `json:"message"`
}

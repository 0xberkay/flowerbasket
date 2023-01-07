package models

import (
	"database/sql"
	"time"
)

type UserAdmin struct {
	UserId   uint           `json:"userId"`
	UserName string         `json:"username"`
	Email    string         `json:"email"`
	Password string         `json:"password"`
	Code     sql.NullString `json:"code"`
}

type StatuAdmin struct {
	StatuId   uint   `json:"statuId"`
	StatuName string `json:"statuName"`
}

type SellersAdmin struct {
	SellerId uint           `json:"sellerId"`
	Company  string         `json:"company"`
	Password string         `json:"password"`
	Email    string         `json:"email"`
	Point    float32        `json:"point"`
	Phone    string         `json:"phone"`
	Trust    bool           `json:"trust"`
	Code     sql.NullString `json:"code"`
}

type ProductAdmin struct {
	ProductId   uint      `json:"productId"`
	ProductName string    `json:"productName"`
	SellerId    uint      `json:"sellerId"`
	Description string    `json:"description"`
	ImageId     uint      `json:"imageId"`
	Price       float32   `json:"price"`
	Stock       uint      `json:"stock"`
	CreatedAt   time.Time `json:"createdAt"`
	CategoryId  uint      `json:"categoryId"`
	Point       float32   `json:"point"`
}

type OrderAdmin struct {
	OrderId      uint      `json:"orderId"`
	UserId       uint      `json:"userId"`
	ProductId    uint      `json:"productId"`
	ProductCount uint      `json:"productCount"`
	StatuId      uint      `json:"statuId"`
	AddressId    uint      `json:"addressId"`
	CreatedAt    time.Time `json:"createdAt"`
	MessageId    uint      `json:"messageId"`
}

type ImagesAdmin struct {
	ImageId  uint   `json:"imageId"`
	SellerId uint   `json:"sellerId"`
	Link     string `json:"link"`
}

type CommentAdmin struct {
	CommentId uint    `json:"commentId"`
	ProductId uint    `json:"productId"`
	UserId    uint    `json:"userId"`
	Point     float32 `json:"point"`
	Comment   string  `json:"comment"`
	OrderId   uint    `json:"orderId"`
}

type CategoryAdmin struct {
	CategoryId   uint   `json:"categoryId"`
	CategoryName string `json:"categoryName"`
}

type CartAdmin struct {
	CartId    uint    `json:"cartId"`
	UserId    uint    `json:"userId"`
	ProductId uint    `json:"productId"`
	Count     uint    `json:"count"`
	Price     float32 `json:"price"`
	MessageId uint    `json:"messageId"`
}

type CartMessageAdmin struct {
	MessageId     uint   `json:"messageId"`
	CartId        uint   `json:"cartId"`
	Message       string `json:"message"`
	NameInMessage string `json:"nameInMessage"`
}

type AddressAdmin struct {
	AddressId uint    `json:"addressId"`
	UserId    uint    `json:"userId"`
	Street    string  `json:"street"`
	City      string  `json:"city"`
	State     string  `json:"state"`
	ZipCode   string  `json:"zipCode"`
	Detail    string  `json:"detail"`
	Show      bool    `json:"show"`
	Latitude  float32 `json:"latitude"`
	Longitude float32 `json:"longitude"`
}

package mailsender

import (
	"ciceksepeti/database"
	"fmt"

	"gopkg.in/gomail.v2"
)

func SendNotification(orderId string) {

	//find username , productname , from orderid

	row := database.DB.QueryRow(`
	SELECT u.username ,u.email, p.productName ,s.statuName FROM Orders o 
	INNER JOIN Users u 
	 ON o.userId = u.userId 
	 INNER JOIN Products p 
	 ON o.productId = p.productId 
     INNER JOIN StatusCodes s
     ON o.statuId = s.statuId
    WHERE o.orderId = ?`, orderId)

	var username string
	var email string
	var productName string
	var statuName string

	err := row.Scan(&username, &email, &productName, &statuName)

	if err != nil {
		database.Lof.Println("Error while selecting username, email, productname, statuname: ", err.Error())
	}

	// This is the message to send in the mail
	msg := fmt.Sprintf("<h3>Hi %s, </h3> <br/>Your order for %s has been %s.<br/>Best regards.", username, productName, statuName)

	m := gomail.NewMessage()

	m.SetHeader("From", *database.Mail)
	m.SetHeader("To", email)
	m.SetHeader("Subject", "Order Notification")
	m.SetBody("text/html", msg)

	dialer(m)
}

func SendNotificationToSeller(productName string, ProductCount uint, email string) {

	//find username , productname , from orderid

	// This is the message to send in the mail
	msg := fmt.Sprintf("<h3>Hi Seller, </h3> <br/>You have a new order for your product %s, the quantity is %d.<br/>Best regards.", productName, ProductCount)

	m := gomail.NewMessage()

	m.SetHeader("From", *database.Mail)
	m.SetHeader("To", email)
	m.SetHeader("Subject", "Order Notification")
	m.SetBody("text/html", msg)

	dialer(m)
}

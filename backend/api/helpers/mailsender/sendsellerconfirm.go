package mailsender

import (
	"ciceksepeti/database"
	"fmt"

	"gopkg.in/gomail.v2"
)

func SendSellerConfirm(sellerID string) {
	var company, email string
	err := database.DB.QueryRow("SELECT email,company FROM Sellers WHERE sellerId = ?", sellerID).Scan(&email, &company)
	if err != nil {
		go database.Lof.Println("Error while getting seller's email: ", sellerID, err)
	} else {
		// This is the message to send in the mail
		msg := fmt.Sprintf("<h3>Hi %s, </h3> <br/> Your account has been confirmed", company)

		m := gomail.NewMessage()

		m.SetHeader("From", *database.Mail)
		m.SetHeader("To", email)
		m.SetHeader("Subject", "Account Confirmation")
		m.SetBody("text/html", msg)

		dialer(m)

		go database.Lof.Println("SendSellerConfirm | mail sent to: ", email)
	}

}

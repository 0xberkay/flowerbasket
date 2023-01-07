package mailsender

import (
	"ciceksepeti/database"
	"fmt"

	"gopkg.in/gomail.v2"
)

func SendCode(email string, name string, code string, userType string, basename string) {
	code = basename + "/" + userType + "/confirmcode?code=" + code
	// This is the message to send in the mail
	msg := fmt.Sprintf("<h3>Hi %s, </h3> <br/>You can use the following code to verify your account:<br/> <b> %s </b><br/>Best regards.", name, code)

	m := gomail.NewMessage()

	m.SetHeader("From", *database.Mail)
	m.SetHeader("To", email)
	m.SetHeader("Subject", "Account Verification")
	m.SetBody("text/html", msg)

	dialer(m)
}

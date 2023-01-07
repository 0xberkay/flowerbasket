package mailsender

import (
	"ciceksepeti/database"
	"crypto/tls"

	"gopkg.in/gomail.v2"
)

// SendMail sends mail
func dialer(m *gomail.Message) *gomail.Dialer {
	from := *database.Mail
	password := *database.Pass
	host := *database.MailServer

	d := gomail.NewDialer(host, 587, from, password)
	d.TLSConfig = &tls.Config{InsecureSkipVerify: true}

	err := d.DialAndSend(m)
	if err != nil {
		database.Lof.Println("Error while sending mail: ", err)
	}

	return d
}

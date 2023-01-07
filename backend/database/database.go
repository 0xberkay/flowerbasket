package database

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"
)

var (
	debug           = flag.Bool("debug", false, "enable debugging")
	password        = flag.String("password", "", "the database password")
	port       *int = flag.Int("port", 1433, "the database port")
	server          = flag.String("server", "", "the database server")
	user            = flag.String("user", "", "the database user")
	dbName          = flag.String("database", "master", "the database name")
	Mail            = flag.String("mail", "", "mail address")
	Pass            = flag.String("mailpass", "", "the mail password")
	MailServer      = flag.String("mailserver", "", "the mail server")
	DB         sql.DB
	Secret     []byte
	Secret2    []byte
	outfile, _ = os.OpenFile("./log/handler.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	Lof        = log.New(outfile, "", log.LstdFlags|log.Lshortfile)
)

// Connect to the database
func Connect() {
	// Secret = []byte(helpers.RandStringBytesMaskImprSrcSB(20))
	Secret = []byte("secret")
	Secret2 = []byte("secret2")

	if *debug {
		fmt.Printf(" password:%s\n", *password)
		fmt.Printf(" port:%d\n", *port)
		fmt.Printf(" server:%s\n", *server)
		fmt.Printf(" user:%s\n", *user)
		fmt.Printf(" database:%s\n", *dbName)
	}

	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", *server, *user, *password, *port, *dbName)
	if *debug {
		fmt.Printf(" connString:%s\n", connString)
	}
	conn, err := sql.Open("mssql", connString)
	if err != nil {
		log.Fatal("Open connection failed:", err.Error())
	}

	DB = *conn
	Ping()

	defer conn.Close()
}

// Ping the database
func Ping() {
	err := DB.Ping()
	if err != nil {
		log.Fatal("Ping failed:", err.Error())
	}
	log.Println("Ping succeeded.")
}

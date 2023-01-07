package main

import (
	"ciceksepeti/api"
	"ciceksepeti/database"
	"flag"

	_ "github.com/denisenkom/go-mssqldb"
)

func init() {
	flag.Parse()
	database.Connect()

}

func main() {
	api.Api()
}

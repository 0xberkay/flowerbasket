package seller

import (
	"ciceksepeti/database"
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/xuri/excelize/v2"
)

// OrdersExcelChart returns excel chart of orders status
func OrdersExcelChart(c *fiber.Ctx) error {
	//claims
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	//id
	sellerID := uint(claims["sub"].(float64))

	f := excelize.NewFile()

	//get orders
	rows, err := database.DB.Query(`
	SELECT StatusCodes.statuName, COUNT(StatusCodes.statuName) as count
	FROM Orders
    JOIN StatusCodes ON Orders.statuId = StatusCodes.statuId
	JOIN Products ON Orders.productId = Products.productId
    WHERE Products.sellerId = ?
	GROUP BY StatusCodes.statuName
	`, sellerID)

	if err != nil {
		return err
	}

	count := 1
	for rows.Next() {
		var countData int
		var statusName string
		err := rows.Scan(&statusName, &countData)
		if err != nil {
			return err
		}

		f.SetCellValue("Sheet1", fmt.Sprintf("A%d", count), statusName)
		f.SetCellValue("Sheet1", fmt.Sprintf("B%d", count), countData)
		count++
	}

	if err := f.AddChart("Sheet1", "E1", `{ 
		"type": "pie",
		"series": [
			{
				"name": "Orders",
				"categories": "=Sheet1!$A$1:$A$3",
				"values": "=Sheet1!$B$1:$B$3"
			}
		]
	}`); err != nil {
		return err
	}

	//return file
	//new buffer
	buf, err := f.WriteToBuffer()
	if err != nil {
		return err
	}

	//set headers
	c.Set("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
	c.Set("Content-Disposition", "attachment; filename=ordersc.xlsx")
	c.Set("Content-Length", fmt.Sprintf("%d", len(buf.Bytes())))
	c.Set("Content-Transfer-Encoding", "binary")

	return c.SendStream(buf)
}

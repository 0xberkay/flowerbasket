package seller

import (
	"ciceksepeti/database"
	"ciceksepeti/models"
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"github.com/xuri/excelize/v2"
)

// OrdersExcel returns excel file of orders
func OrdersExcel(c *fiber.Ctx) error {
	//claims
	userToken := c.Locals("user").(*jwt.Token)
	claims := userToken.Claims.(jwt.MapClaims)

	//id
	sellerID := uint(claims["sub"].(float64))

	//get orders
	rows, err := database.DB.Query(`
	SELECT Orders.*, Products.sellerId,StatusCodes.statuName,Address.street,
	Address.city,Address.state,Address.zipCode,Address.detail,CartMessages.message,CartMessages.nameInMessage
		FROM Orders
		JOIN Products ON Orders.productId = Products.productId
		JOIN StatusCodes ON Orders.statuId = StatusCodes.statuId
		JOIN Address ON Orders.addressId = Address.addressId
		JOIN CartMessages ON Orders.messageId = CartMessages.messageId
		Where Products.sellerId = ?
	`, sellerID)

	if err != nil {
		return err
	}

	f := excelize.NewFile()

	//set headers
	f.SetCellValue("Sheet1", "A1", "OrderID")
	f.SetCellValue("Sheet1", "B1", "UserID")
	f.SetCellValue("Sheet1", "C1", "ProductID")
	f.SetCellValue("Sheet1", "D1", "ProductCount")
	f.SetCellValue("Sheet1", "E1", "StatuID")
	f.SetCellValue("Sheet1", "F1", "AddressID")
	f.SetCellValue("Sheet1", "G1", "CreatedAt")
	f.SetCellValue("Sheet1", "H1", "SellerID")
	f.SetCellValue("Sheet1", "I1", "StatuName")
	f.SetCellValue("Sheet1", "J1", "Street")
	f.SetCellValue("Sheet1", "K1", "City")
	f.SetCellValue("Sheet1", "L1", "State")
	f.SetCellValue("Sheet1", "M1", "ZipCode")
	f.SetCellValue("Sheet1", "N1", "Detail")
	f.SetCellValue("Sheet1", "O1", "Message")
	f.SetCellValue("Sheet1", "P1", "NameInMessage")

	count := 2
	for rows.Next() {
		var order models.OrderDetail
		err := rows.Scan(&order.OrderID, &order.UserID, &order.ProductID, &order.ProductCount, &order.StatuID, &order.AddressID, &order.CreatedAt, &order.MessageID, &order.SellerID, &order.StatuName, &order.Street, &order.City, &order.State, &order.ZipCode, &order.Detail, &order.Message, &order.NameInMessage)
		if err != nil {
			return err
		}

		//set values
		f.SetCellValue("Sheet1", fmt.Sprintf("A%d", count), order.OrderID)
		f.SetCellValue("Sheet1", fmt.Sprintf("B%d", count), order.UserID)
		f.SetCellValue("Sheet1", fmt.Sprintf("C%d", count), order.ProductID)
		f.SetCellValue("Sheet1", fmt.Sprintf("D%d", count), order.ProductCount)
		f.SetCellValue("Sheet1", fmt.Sprintf("E%d", count), order.StatuID)
		f.SetCellValue("Sheet1", fmt.Sprintf("F%d", count), order.AddressID)
		f.SetCellValue("Sheet1", fmt.Sprintf("G%d", count), order.CreatedAt)
		f.SetCellValue("Sheet1", fmt.Sprintf("H%d", count), order.SellerID)
		f.SetCellValue("Sheet1", fmt.Sprintf("I%d", count), order.StatuName)
		f.SetCellValue("Sheet1", fmt.Sprintf("J%d", count), order.Street)
		f.SetCellValue("Sheet1", fmt.Sprintf("K%d", count), order.City)
		f.SetCellValue("Sheet1", fmt.Sprintf("L%d", count), order.State)
		f.SetCellValue("Sheet1", fmt.Sprintf("M%d", count), order.ZipCode)
		f.SetCellValue("Sheet1", fmt.Sprintf("N%d", count), order.Detail)
		f.SetCellValue("Sheet1", fmt.Sprintf("O%d", count), order.Message)
		f.SetCellValue("Sheet1", fmt.Sprintf("P%d", count), order.NameInMessage)
		count++
	}

	//return file
	//new buffer
	buf, err := f.WriteToBuffer()
	if err != nil {
		return err
	}

	//set headers
	c.Set("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
	c.Set("Content-Disposition", "attachment; filename=orders.xlsx")
	c.Set("Content-Length", fmt.Sprintf("%d", len(buf.Bytes())))
	c.Set("Content-Transfer-Encoding", "binary")

	return c.SendStream(buf)
}

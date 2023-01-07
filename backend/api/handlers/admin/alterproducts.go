package admin

import (
	"ciceksepeti/api/handlers/errorHandler"
	"ciceksepeti/database"

	"github.com/gofiber/fiber/v2"
)

// AlterProducts updates the products stored procedure
func AlterProducts(c *fiber.Ctx) error {

	_, err := database.DB.Exec(`	
	-- Create the stored procedure in the specified schema
	ALTER PROCEDURE [dbo].[SearchProduct] @query NVARCHAR(50)
	AS
	BEGIN
		DECLARE @search VARCHAR(50) = CONCAT('%',@query,'%')
		SELECT  * FROM TrustedProducts
			WHERE productName LIKE @search OR description LIKE @search OR categoryName LIKE @search OR company LIKE @search
			ORDER BY point DESC
	END
	`)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	_, err = database.DB.Exec(`	
	-- Modify the SelectAllProducts stored procedure
	ALTER PROCEDURE [dbo].[SelectAllProducts]
	AS
	BEGIN
		-- Set no count on
		SET NOCOUNT ON;
	
		-- Select all products
		SELECT * FROM TrustedProducts
	END
	`)
	if err != nil {
		return errorHandler.InternalServerError(c)
	}

	return c.JSON(fiber.Map{
		"message": "Products updated",
	})
}

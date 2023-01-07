/*
Deployment script for CicekSepeti
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "CicekSepeti"
:setvar DefaultFilePrefix "CicekSepeti"
:setvar DefaultDataPath "/var/opt/mssql/data/"
:setvar DefaultLogPath "/var/opt/mssql/data/"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating SqlTable [dbo].[Address]...';


GO
CREATE TABLE [dbo].[Address] (
    [addressId] INT             IDENTITY (1, 1) NOT NULL,
    [userId]    INT             NOT NULL,
    [street]    NVARCHAR (30)   NOT NULL,
    [city]      NVARCHAR (30)   NOT NULL,
    [state]     VARCHAR (30)    NOT NULL,
    [zipCode]   VARCHAR (5)     NOT NULL,
    [detail]    NVARCHAR (255)  NULL,
    [show]      VARCHAR (1)     NOT NULL,
    [latitude]  DECIMAL (10, 8) NULL,
    [longitude] DECIMAL (11, 8) NULL,
    CONSTRAINT [PK_address] PRIMARY KEY CLUSTERED ([addressId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[CartMessages]...';


GO
CREATE TABLE [dbo].[CartMessages] (
    [messageId]     INT           IDENTITY (0, 1) NOT NULL,
    [cartId]        INT           NOT NULL,
    [message]       NTEXT         NOT NULL,
    [nameInMessage] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_CartMessages] PRIMARY KEY CLUSTERED ([messageId] ASC),
    UNIQUE NONCLUSTERED ([cartId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Carts]...';


GO
CREATE TABLE [dbo].[Carts] (
    [cartId]    INT        IDENTITY (1, 1) NOT NULL,
    [userId]    INT        NOT NULL,
    [productId] INT        NOT NULL,
    [count]     INT        NOT NULL,
    [price]     FLOAT (53) NOT NULL,
    [messageId] INT        NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY CLUSTERED ([cartId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Categories]...';


GO
CREATE TABLE [dbo].[Categories] (
    [categoryId]   INT          IDENTITY (1, 1) NOT NULL,
    [categoryName] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([categoryId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Comments]...';


GO
CREATE TABLE [dbo].[Comments] (
    [commentId] INT            IDENTITY (1, 1) NOT NULL,
    [productId] INT            NOT NULL,
    [userId]    INT            NOT NULL,
    [point]     FLOAT (53)     NOT NULL,
    [comment]   NVARCHAR (255) NOT NULL,
    [orderId]   INT            NOT NULL,
    CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED ([commentId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Images]...';


GO
CREATE TABLE [dbo].[Images] (
    [imageId]  INT            IDENTITY (1, 1) NOT NULL,
    [sellerId] INT            NULL,
    [link]     NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED ([imageId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Orders]...';


GO
CREATE TABLE [dbo].[Orders] (
    [orderId]      INT      IDENTITY (1, 1) NOT NULL,
    [userId]       INT      NOT NULL,
    [productId]    INT      NOT NULL,
    [productCount] INT      NOT NULL,
    [statuId]      INT      NULL,
    [addressId]    INT      NOT NULL,
    [createdAt]    DATETIME NULL,
    [messageId]    INT      NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([orderId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Products]...';


GO
CREATE TABLE [dbo].[Products] (
    [productId]   INT           IDENTITY (1, 1) NOT NULL,
    [productName] NVARCHAR (30) NOT NULL,
    [sellerId]    INT           NOT NULL,
    [description] NTEXT         NOT NULL,
    [imageId]     INT           NOT NULL,
    [price]       FLOAT (53)    NOT NULL,
    [stock]       INT           NOT NULL,
    [createdAt]   DATETIME      NOT NULL,
    [categoryId]  INT           NOT NULL,
    [point]       FLOAT (53)    NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([productId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Sellers]...';


GO
CREATE TABLE [dbo].[Sellers] (
    [sellerId] INT            IDENTITY (1, 1) NOT NULL,
    [company]  NVARCHAR (50)  NOT NULL,
    [password] NVARCHAR (100) NOT NULL,
    [email]    NVARCHAR (50)  NOT NULL,
    [point]    FLOAT (53)     NULL,
    [phone]    NVARCHAR (15)  NOT NULL,
    [trust]    BIT            NOT NULL,
    [code]     NCHAR (20)     NULL,
    CONSTRAINT [PK_Sellers] PRIMARY KEY CLUSTERED ([sellerId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[StatusCodes]...';


GO
CREATE TABLE [dbo].[StatusCodes] (
    [statuId]   INT           IDENTITY (1, 1) NOT NULL,
    [statuName] NVARCHAR (30) NOT NULL,
    CONSTRAINT [PK_StatusCodes] PRIMARY KEY CLUSTERED ([statuId] ASC)
);


GO
PRINT N'Creating SqlTable [dbo].[Users]...';


GO
CREATE TABLE [dbo].[Users] (
    [userId]   INT            IDENTITY (1, 1) NOT NULL,
    [username] NVARCHAR (50)  NOT NULL,
    [email]    NVARCHAR (100) NOT NULL,
    [password] NVARCHAR (100) NOT NULL,
    [code]     NVARCHAR (20)  NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([userId] ASC),
    UNIQUE NONCLUSTERED ([email] ASC),
    UNIQUE NONCLUSTERED ([username] ASC),
    UNIQUE NONCLUSTERED ([username] ASC)
);


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Address_show]...';


GO
ALTER TABLE [dbo].[Address]
    ADD CONSTRAINT [DEFAULT_Address_show] DEFAULT ((1)) FOR [show];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Carts_count]...';


GO
ALTER TABLE [dbo].[Carts]
    ADD CONSTRAINT [DEFAULT_Carts_count] DEFAULT ((1)) FOR [count];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Carts_messageId]...';


GO
ALTER TABLE [dbo].[Carts]
    ADD CONSTRAINT [DEFAULT_Carts_messageId] DEFAULT ((0)) FOR [messageId];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Orders_messageId]...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DEFAULT_Orders_messageId] DEFAULT ((0)) FOR [messageId];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Orders_productCount]...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DEFAULT_Orders_productCount] DEFAULT ((1)) FOR [productCount];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Orders_statuId]...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DEFAULT_Orders_statuId] DEFAULT ((1)) FOR [statuId];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Orders_createdAt]...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DEFAULT_Orders_createdAt] DEFAULT (sysdatetime()) FOR [createdAt];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Products_createdAt]...';


GO
ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [DEFAULT_Products_createdAt] DEFAULT (sysdatetime()) FOR [createdAt];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Products_point]...';


GO
ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [DEFAULT_Products_point] DEFAULT ((0)) FOR [point];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Seller_trust]...';


GO
ALTER TABLE [dbo].[Sellers]
    ADD CONSTRAINT [DEFAULT_Seller_trust] DEFAULT ((0)) FOR [trust];


GO
PRINT N'Creating SqlDefaultConstraint [dbo].[DEFAULT_Sellers_point]...';


GO
ALTER TABLE [dbo].[Sellers]
    ADD CONSTRAINT [DEFAULT_Sellers_point] DEFAULT ((0)) FOR [point];


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_address_Users]...';


GO
ALTER TABLE [dbo].[Address] WITH NOCHECK
    ADD CONSTRAINT [FK_address_Users] FOREIGN KEY ([userId]) REFERENCES [dbo].[Users] ([userId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_CartMessages_CartMessages]...';


GO
ALTER TABLE [dbo].[CartMessages] WITH NOCHECK
    ADD CONSTRAINT [FK_CartMessages_CartMessages] FOREIGN KEY ([cartId]) REFERENCES [dbo].[CartMessages] ([cartId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Carts_Products]...';


GO
ALTER TABLE [dbo].[Carts] WITH NOCHECK
    ADD CONSTRAINT [FK_Carts_Products] FOREIGN KEY ([productId]) REFERENCES [dbo].[Products] ([productId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Carts_CartMessages]...';


GO
ALTER TABLE [dbo].[Carts] WITH NOCHECK
    ADD CONSTRAINT [FK_Carts_CartMessages] FOREIGN KEY ([messageId]) REFERENCES [dbo].[CartMessages] ([messageId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Carts_Users]...';


GO
ALTER TABLE [dbo].[Carts] WITH NOCHECK
    ADD CONSTRAINT [FK_Carts_Users] FOREIGN KEY ([userId]) REFERENCES [dbo].[Users] ([userId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Comments_Products]...';


GO
ALTER TABLE [dbo].[Comments] WITH NOCHECK
    ADD CONSTRAINT [FK_Comments_Products] FOREIGN KEY ([productId]) REFERENCES [dbo].[Products] ([productId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Comments_Orders]...';


GO
ALTER TABLE [dbo].[Comments] WITH NOCHECK
    ADD CONSTRAINT [FK_Comments_Orders] FOREIGN KEY ([orderId]) REFERENCES [dbo].[Orders] ([orderId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Comments_Users]...';


GO
ALTER TABLE [dbo].[Comments] WITH NOCHECK
    ADD CONSTRAINT [FK_Comments_Users] FOREIGN KEY ([userId]) REFERENCES [dbo].[Users] ([userId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Images_Sellers]...';


GO
ALTER TABLE [dbo].[Images] WITH NOCHECK
    ADD CONSTRAINT [FK_Images_Sellers] FOREIGN KEY ([sellerId]) REFERENCES [dbo].[Sellers] ([sellerId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Orders_CartMessages]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_Orders_CartMessages] FOREIGN KEY ([messageId]) REFERENCES [dbo].[CartMessages] ([messageId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Orders_Products]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_Orders_Products] FOREIGN KEY ([productId]) REFERENCES [dbo].[Products] ([productId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Orders_Users]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_Orders_Users] FOREIGN KEY ([userId]) REFERENCES [dbo].[Users] ([userId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Orders_Address]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_Orders_Address] FOREIGN KEY ([addressId]) REFERENCES [dbo].[Address] ([addressId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Orders_StatusCodes]...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_Orders_StatusCodes] FOREIGN KEY ([statuId]) REFERENCES [dbo].[StatusCodes] ([statuId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Products_Images]...';


GO
ALTER TABLE [dbo].[Products] WITH NOCHECK
    ADD CONSTRAINT [FK_Products_Images] FOREIGN KEY ([imageId]) REFERENCES [dbo].[Images] ([imageId]);


GO
PRINT N'Creating SqlForeignKeyConstraint [dbo].[FK_Products_Categories]...';


GO
ALTER TABLE [dbo].[Products] WITH NOCHECK
    ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[Categories] ([categoryId]);


GO
PRINT N'Creating SqlCheckConstraint [dbo].[CK_Products_1]...';


GO
ALTER TABLE [dbo].[Products] WITH NOCHECK
    ADD CONSTRAINT [CK_Products_1] CHECK ([point]<(6) AND [point]>=(0));


GO
PRINT N'Creating SqlCheckConstraint [dbo].[CK_Sellers_1]...';


GO
ALTER TABLE [dbo].[Sellers] WITH NOCHECK
    ADD CONSTRAINT [CK_Sellers_1] CHECK ([point]<(6) AND [point]>=(0));


GO
PRINT N'Creating SqlDmlTrigger [dbo].[CartMessages_Insert]...';


GO
--trigger on new CartMessages insert
-- add new message to the carts
CREATE TRIGGER [dbo].[CartMessages_Insert]
ON [dbo].[CartMessages]
AFTER INSERT
AS
BEGIN
    -- Update the cart WİTH new messageId
    UPDATE Carts
    SET Carts.messageId = (SELECT MAX(messageId) FROM CartMessages)
    WHERE CartId = (SELECT CartId FROM inserted)
END
GO
PRINT N'Creating SqlDmlTrigger [dbo].[tr_cart_count]...';


GO
-- triger on update cart 
-- update product stock

CREATE TRIGGER tr_cart_count
ON Carts
AFTER UPDATE 
AS
BEGIN
    UPDATE Products SET stock = stock + (SELECT [count] FROM deleted) - (SELECT count FROM inserted)
    WHERE productId = (SELECT productId FROM inserted)

END
GO
PRINT N'Creating SqlDmlTrigger [dbo].[Update_Products]...';


GO
--trigger for insert into table 'carts' 


CREATE TRIGGER Update_Products
ON carts
AFTER INSERT
AS
BEGIN
    UPDATE products SET stock = stock - (SELECT count FROM inserted) WHERE productId = (SELECT productId FROM inserted)
END
GO
PRINT N'Creating SqlDmlTrigger [dbo].[Comments_Insert]...';


GO
--trigger on new comments insert
--trigger on new Comment insert
-- update point of Seller and Product
CREATE TRIGGER [dbo].[Comments_Insert]
ON [dbo].[Comments]
AFTER INSERT
AS
BEGIN
   declare @SellerID int
    --get SellerID
    SELECT @SellerID = SellerID FROM Products WHERE ProductID = (SELECT ProductID FROM inserted)
    --update Seller Point with average of all comments
    update Sellers SET Point = (SELECT AVG(Point) FROM Comments WHERE SellerID = @SellerID) WHERE SellerID = @SellerID

    --update Product Point with average of all comments
    update Products SET Point = (SELECT AVG(Point) FROM Comments WHERE ProductID = (SELECT ProductID FROM inserted)) WHERE ProductID = (SELECT ProductID FROM inserted)

    --update Order statu
    update Orders SET statuId = 6 WHERE orderId = (SELECT orderId FROM inserted) 
END
GO
PRINT N'Creating SqlView [dbo].[TrustedProducts]...';


GO
CREATE VIEW [dbo].[TrustedProducts] AS
	SELECT  productId,Sellers.company,Sellers.sellerId, productName, description, price, stock, Categories.categoryName, Images.link,Products.point
	FROM products JOIN categories
	ON categories.categoryID = products.categoryID
	JOIN sellers
    ON Sellers.sellerId = Products.sellerId
    JOIN images
	ON Images.imageId = Products.imageId
    WHERE Sellers.trust = 1
GO
PRINT N'Creating SqlProcedure [dbo].[CommentsConfirmed]...';


GO
CREATE PROCEDURE [dbo].[CommentsConfirmed] @id INT
AS
BEGIN
    SELECT u.username,c.comment,c.point FROM comments c 
	JOIN Users u ON c.userId = u.userId 
    WHERE c.productId = @id
END
GO
PRINT N'Creating SqlProcedure [dbo].[SearchProduct]...';


GO
	CREATE PROCEDURE [dbo].[SearchProduct] @query NVARCHAR(50)
	AS
	BEGIN
		DECLARE @search VARCHAR(50) = CONCAT('%',@query,'%')
		SELECT  * FROM TrustedProducts
			WHERE productName LIKE @search OR description LIKE @search OR categoryName LIKE @search OR company LIKE @search
			ORDER BY point DESC
	END
GO
PRINT N'Creating SqlProcedure [dbo].[SelectAllCategories]...';


GO
CREATE PROCEDURE [dbo].[SelectAllCategories]
AS
BEGIN
    SELECT * FROM Categories
END
GO
PRINT N'Creating SqlProcedure [dbo].[SelectAllProducts]...';


GO
CREATE PROCEDURE dbo.SelectAllProducts
AS
BEGIN
    SELECT * FROM TrustedProducts
END
GO
PRINT N'Creating SqlProcedure [dbo].[SelectAllStatusCodes]...';


GO
CREATE PROCEDURE [dbo].[SelectAllStatusCodes]
AS
BEGIN
    SELECT * FROM StatusCodes
END
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Address] WITH CHECK CHECK CONSTRAINT [FK_address_Users];

ALTER TABLE [dbo].[CartMessages] WITH CHECK CHECK CONSTRAINT [FK_CartMessages_CartMessages];

ALTER TABLE [dbo].[Carts] WITH CHECK CHECK CONSTRAINT [FK_Carts_Products];

ALTER TABLE [dbo].[Carts] WITH CHECK CHECK CONSTRAINT [FK_Carts_CartMessages];

ALTER TABLE [dbo].[Carts] WITH CHECK CHECK CONSTRAINT [FK_Carts_Users];

ALTER TABLE [dbo].[Comments] WITH CHECK CHECK CONSTRAINT [FK_Comments_Products];

ALTER TABLE [dbo].[Comments] WITH CHECK CHECK CONSTRAINT [FK_Comments_Orders];

ALTER TABLE [dbo].[Comments] WITH CHECK CHECK CONSTRAINT [FK_Comments_Users];

ALTER TABLE [dbo].[Images] WITH CHECK CHECK CONSTRAINT [FK_Images_Sellers];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_Orders_CartMessages];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_Orders_Products];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_Orders_Users];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_Orders_Address];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_Orders_StatusCodes];

ALTER TABLE [dbo].[Products] WITH CHECK CHECK CONSTRAINT [FK_Products_Images];

ALTER TABLE [dbo].[Products] WITH CHECK CHECK CONSTRAINT [FK_Products_Categories];

ALTER TABLE [dbo].[Products] WITH CHECK CHECK CONSTRAINT [CK_Products_1];

ALTER TABLE [dbo].[Sellers] WITH CHECK CHECK CONSTRAINT [CK_Sellers_1];


GO
PRINT N'Update complete.';


GO

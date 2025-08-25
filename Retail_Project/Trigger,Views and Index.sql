
-- CREATE VIW TO SUMMERISED DATA

-- ORDER SUMMERY REPORT

CREATE VIEW ORDER_SUMMERY
AS
SELECT ORDERS.OrderId,USERS.FullName AS CustomerName,VENDORS.VendorName,ORDERS.OrderDate, ORDERITEMS.OrderQuentity
FROM ORDERS JOIN USERS ON USERS.UserId = ORDERS.UserId
JOIN VENDORS ON VENDORS.VendorId = ORDERS.OrderId
JOIN ORDERITEMS ON ORDERS.OrderId = ORDERITEMS.OrderId;

SELECT * FROM ORDER_SUMMERY;


-- PRODUCTS SALES SUMMERY REPORT

CREATE VIEW SALES_REPORT
AS
SELECT PRODUCTS.ProductName, SUM(ORDERITEMS.OrderQuentity ) AS Total_Sales
FROM PRODUCTS JOIN ORDERITEMS ON PRODUCTS.ProductId = ORDERITEMS.ProductId
JOIN ORDERS ON ORDERS.OrderId = ORDERITEMS.OrderId
GROUP BY PRODUCTS.ProductName;

SELECT * FROM SALES_REPORT;




-- CREATE INDEXES TO IMPROVE PERFORMANCE

SELECT * FROM USERS WHERE FullName LIKE '% J%'

CREATE NONCLUSTERED INDEX MY_CLUSTER ON USERS(FullName);

SELECT * FROM USERS WHERE FullName LIKE '% J%';

select * from VENDORS;

CREATE NONCLUSTERED INDEX VENDOR_CLUSTER ON VENDORS(VendorName);

SELECT * FROM VENDORS WHERE VendorName like '%B%'


-- CREATE STORE PROCEDURE

-- INSERT NEW ORDERS DATA USING STORE PROCEDURE

SELECT * FROM ORDERITEMS;

create Type OrderItemType as Table(
Product_Id Int,
Order_Quantity int,
Order_Price decimal(10,2)
);


CREATE OR ALTER PROCEDURE INSERT_DATA
@User_Id int,
@Vendor_Id int,
@Total_Amount decimal(10,2),
@ItemList as dbo.OrderItemType readonly

as
BEGIN
	
	set nocount on;

	declare @NewOrderId int;


	-- Insert into Orders
	INSERT INTO ORDERS(UserId,VendorId,OrderDate,TotalAmount)
	VALUES(@User_Id,@Vendor_Id,getdate(),@Total_Amount);

	-- INSERT INTO ORDER_ITEMS
	set @NewOrderId = scope_identity();

	INSERT INTO ORDERITEMS(OrderId,ProductId,OrderQuentity,Price)
	SELECT @NewOrderId,Product_Id,Order_Quantity,Order_Price from @ItemList

end;

declare @items as dbo.OrderItemType;

insert into @items values(1,4,55.00);
execute INSERT_DATA 
@User_Id = 1,
@Vendor_Id = 2,
@Total_Amount = 70.00,
@ItemList = @ITEMS;


select * from Inventory where ProductId = 1;
select * from orderitems;


-- CREATE TRIGGER FOR UPDATION IN INVENTORY TABLE

CREATE  TRIGGER UPDATE_STOCK
ON ORDERITEMS 
AFTER INSERT
AS
	BEGIN
		
		UPDATE inv  SET inv.AvailableQuantity = inv.AvailableQuantity - ins.OrderQuentity
		from INVENTORY as inv join inserted ins on inv.ProductId = ins.ProductId

	END;

	

	
use StockAuction;

alter table StockAuction.AuctionClientAtAuction add TotalValuePurchase decimal(8,2);
alter table StockAuction.AuctionClientAtAuction add TotalValueSell decimal(8,2);




drop trigger if exists UpdateTotalValuePurchase_ai; 
delimiter $$
CREATE 
    TRIGGER  UpdateTotalValuePurchase_ai
 AFTER INSERT ON CattleLot FOR EACH ROW 
    BEGIN 
-- Buyer    
    declare TotalValueBought  decimal(8,2);    
	declare TotalValueSold decimal(8,2);
SELECT 
    SUM(new.lotSellingPrice)
INTO TotalValueBought  FROM
    CattleLot
WHERE
    buyer = new.buyer
        AND auctionday = new.auctionDay
GROUP BY buyer;
UPDATE AuctionClientAtAuction 
SET 
    TotalValuePurchase = TotalValueBought 
WHERE
    AuctionClientAtAuction.auctionId = new.auctionDay
        AND AuctionClientAtAuction.clientNumber = new.buyer;
-- Seller
SELECT 
    SUM(new.lotSellingPrice)
INTO TotalValueSold  FROM
    CattleLot
WHERE
    seller = new.seller
        AND auctionday = new.auctionDay
GROUP BY seller;
UPDATE AuctionClientAtAuction 
SET 
    TotalValueSell = TotalValueSold 
WHERE
    AuctionClientAtAuction.auctionId = new.auctionDay
        AND AuctionClientAtAuction.clientNumber = new.seller;        
    END$$
delimiter ;


-- Tests

-- Show Trigger
select event_object_schema as database_name,
       event_object_table as table_name,
       trigger_name,
       action_order,
       action_timing,
       event_manipulation as trigger_event,
       action_statement as 'definition'
from information_schema.triggers 
where trigger_name = 'UpdateTotalValuePurchase_ai'
order by database_name,
         table_name;
         
         
-- Insert Buyer and Seller
-- Seller
INSERT into AuctionClientAtAuction (auctionId, clientNumber, clientID) VALUES (1620, 2, N'MEG54     ');
INSERT into AuctionClientAtAuction (auctionId, clientNumber, clientID) VALUES (1620, 3, N'MEG54     ');
-- Buyer
INSERT into AuctionClientAtAuction (auctionId, clientNumber, clientID) VALUES (1620, 50, N'VIO55     ');

-- Insert Auction
INSERT CattleLot (auctionId, auctionDay, lotNumber, seller, agent, breed, sex, age, quantity, averageWeight, reserve, auctioneer, buyer, sellingPricePerKg, passedIn) VALUES (N'C1620', 1620, 234, 2, N'F_Don     ', N'Angus X             ', N'S', 3, 17,980.00, NULL, N'F_Don     ', 50, 2.9000, 0); 
INSERT CattleLot (auctionId, auctionDay, lotNumber, seller, agent, breed, sex, age, quantity, averageWeight, reserve, auctioneer, buyer, sellingPricePerKg, passedIn) VALUES (N'C1620', 1620, 99, 3, N'F_Don     ', N'Angus X             ', N'S', 3, 17,980.00, NULL, N'F_Don     ', 50, 2.9000, 0); 

-- Check if The trigger worked
SELECT * FROM StockAuction.AuctionClientAtAuction where clientNumber = 50 and clientID = 'VIO55';
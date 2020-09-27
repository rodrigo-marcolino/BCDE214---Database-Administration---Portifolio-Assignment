use StockAuction;
CREATE VIEW SheepSales2020 AS
    SELECT 
        acbuyers.fullName AS 'Buyers',
        acsellers.fullname AS 'Seller',
        sa.fullName AS 'Agent',
        say.fullName AS 'Agency',
        sl.breed,
        sl.quantity,
        sl.lotSellingPrice
    FROM
        SheepLot sl
            INNER JOIN
        AuctionClientAtAuction aca ON sl.buyer = aca.clientNumber
            AND sl.auctionDay = aca.auctionId
            INNER JOIN
        AuctionClient acbuyers ON aca.clientID = acbuyers.id
            INNER JOIN
        AuctionClientAtAuction acasellers ON sl.seller = acasellers.clientNumber
            AND sl.auctionDay = aca.auctionId
            INNER JOIN
        AuctionClient acsellers ON acasellers.clientID = acsellers.id
            INNER JOIN
        SheepAuction sha ON sl.auctionId = sha.id
            INNER JOIN
        AuctionDay ON sha.auctionId = AuctionDay.id
            INNER JOIN
        StockAgent sa ON sl.agent = sa.id
            AND sl.auctioneer = sa.id
            INNER JOIN
        StockAgency say ON sa.stockAgency = say.id
    WHERE
        YEAR(AuctionDay.auctionDay) = '2020';
        
        
-- Test
SELECT * FROM StockAuction.SheepSales2020;        

-- There is no auction Sheep  in 2020
-- Just in 2019
        
use StockAuction;
CREATE VIEW SheepSales2019 AS
    SELECT 
        acbuyers.fullName AS 'Buyers',
        acsellers.fullname AS 'Seller',
        sa.fullName AS 'Agent',
        say.fullName AS 'Agency',
        sl.breed,
        sl.quantity,
        sl.lotSellingPrice
    FROM
        SheepLot sl
            INNER JOIN
        AuctionClientAtAuction aca ON sl.buyer = aca.clientNumber
            AND sl.auctionDay = aca.auctionId
            INNER JOIN
        AuctionClient acbuyers ON aca.clientID = acbuyers.id
            INNER JOIN
        AuctionClientAtAuction acasellers ON sl.seller = acasellers.clientNumber
            AND sl.auctionDay = aca.auctionId
            INNER JOIN
        AuctionClient acsellers ON acasellers.clientID = acsellers.id
            INNER JOIN
        SheepAuction sha ON sl.auctionId = sha.id
            INNER JOIN
        AuctionDay ON sha.auctionId = AuctionDay.id
            INNER JOIN
        StockAgent sa ON sl.agent = sa.id
            AND sl.auctioneer = sa.id
            INNER JOIN
        StockAgency say ON sa.stockAgency = say.id
    WHERE
        YEAR(AuctionDay.auctionDay) = '2019';    
    
-- test 
SELECT * FROM StockAuction.SheepSales2019;    
-- All lots of cattle sold in 2020.  Include the names of the buyers, sellers, agents and auctioneers, 
-- the number and type sold, and the price per lot.  Do not include passed in lots.

use StockAuction;
create view CattleSales2020 as
SELECT 
    acbuyers.fullName AS 'Buyers',
    acsellers.fullname as 'Seller',
     sa.fullName AS 'Agent',
    say.fullName AS 'Agency',
    cl.breed,
    cl.quantity,
    cl.lotSellingPrice
FROM
    CattleLot cl
        INNER JOIN
        /* buyer*/
    AuctionClientAtAuction aca ON cl.buyer = aca.clientNumber
        INNER JOIN
    AuctionClient acbuyers ON aca.clientID = acbuyers.id
    /* saller*/
    INNER JOIN
    AuctionClientAtAuction acasellers ON cl.seller = acasellers.clientNumber
        AND cl.auctionDay = aca.auctionId
        INNER JOIN
    AuctionClient acsellers ON acasellers.clientID = acsellers.id   
    /* end saller*/
        INNER JOIN
    CattleAuction ca ON cl.auctionId = ca.id
        INNER JOIN
    AuctionDay ON ca.auctionId = AuctionDay.id
        INNER JOIN
    StockAgent sa ON cl.agent = sa.id
        AND cl.auctioneer = sa.id
        INNER JOIN
    StockAgency say ON sa.stockAgency = say.id
WHERE
    YEAR(AuctionDay.auctionDay) = '2020';
    

select CattleSales2020;
    
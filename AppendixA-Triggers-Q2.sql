alter table AuctionClient add AttendanceCounterLastYear int not null;
drop trigger if exists AttendanceCounterLastYear_ai;

DELIMITER $$
CREATE TRIGGER AttendanceCounterLastYear_ai After INSERT ON AuctionClientAtAuction
    for each row
    begin  
		UPDATE AuctionClient 
		SET 
			AttendanceCounterLastYear = AttendanceCounterLastYear + 1
		WHERE
			id = new.clientid and new.auctionid in(SELECT 
		   AuctionClientAtAuction.auctionId
		FROM
			AuctionClientAtAuction
				inner JOIN
			AuctionDay ON AuctionClientAtAuction.auctionId = AuctionDay.id
			where AuctionDay.auctionDay  between DATE_SUB(curdate(),INTERVAL 1 YEAR) and curdate()); 
    end $$
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
where trigger_name = 'AttendanceCounterLastYear_ai'
order by database_name,
         table_name;

-- Insert Data         

insert into AuctionClientAtAuction value(1619, 300 , 'AIK33', null, null);

-- Show Result
SELECT 
    id, fullname, AttendanceCounterLastYear
FROM
    AuctionClient;

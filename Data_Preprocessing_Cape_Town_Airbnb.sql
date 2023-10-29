#Create Duplicate Table with desired Features
create table cape_listings
select id,host_name,host_since,neighbourhood,host_location,latitude,longitude,property_type,room_type,accommodates,bathrooms,bathrooms_text,bedrooms,beds,amenities,price,last_scraped,license
from listings;

#Data Cleaning ---> Cape Listings
	#Format Date
		alter table cape_listings 
		modify column host_since date;
	
		alter table cape_listings 
		modify column last_scraped date;
	
		alter table cape_listings 
		rename column last_scraped to host_now;
	
	#Filter Cape Town,South Africa as the host location
		update cape_listings 
		set host_location = case 
			when neighbourhood like '%South Africa%' then 'South Africa'
			when neighbourhood is null then 'South Africa'
			else host_location
		end;
		
		delete from cape_listings 
		where host_location not like '%South Africa%';

	#Format Bathrooms text to integer
		update cape_listings
		set bathrooms_text = case 
			when bathrooms_text like '%half%' then '1 batth'
			when bathrooms_text like 'Shared%' then '1 bath'
			when bathrooms_text like '%Half%' then '1 bath'
			else bathrooms_text
		end;
	
		delete from cape_listings 
		where bathrooms_text is null;
	
		update cape_listings 
		set bathrooms = left(bathrooms_text,locate(' ',bathrooms_text));
	
		alter table cape_listings 
		modify column bathrooms smallint;
		
		alter table cape_listings 
		drop column bathrooms_text;
	
	#Format Amenities
		update cape_listings
		set amenities = replace(amenities,'[','');
	
		update cape_listings
		set amenities = replace(amenities,']','');
	
		update cape_listings
		set amenities = replace(amenities,'"','');
	
	#Format Price 
		update cape_listings 
		set price = replace(price,'$','');
	
		update cape_listings 
		set price = replace(price,',','');
	
		update cape_listings 
		set price = replace(price,'.','');
	
		alter table cape_listings 
		modify column price bigint;
	
	#Format License
		update cape_listings 
		set license = 'Unknown'
		where license is null;
	
#Data Cleaning ----> Cape Reviews
	#Format Date
		alter table reviews
		modify column date date;

select cl.host_name as host_name,r.date,r.comments
from reviews r
join cape_listings cl 
on r.listing_id = cl.id
where date between '2023-09-20' and '2023-09-23';

#Data Cleaning ----> Cape Calendar
	#Format Date
		alter table calendar 
		modify column date date;
	
	#Format Price
		update calendar 
		set price = replace(price,'$','');
	
		update calendar 
		set adjusted_price = replace(adjusted_price,'$','');
	
		update calendar 
		set price = replace(price,'.00','');
	
		update calendar 
		set price = replace(price,',','');
	
		update calendar 
		set adjusted_price = replace(adjusted_price,'.00','');
	
		update calendar 
		set adjusted_price = replace(adjusted_price,',','');
	
		alter table calendar 
		modify column price bigint;
	
		alter table calendar 
		modify column adjusted_price bigint;
	
select *
from calendar;










-- First way to do join
select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	zpu."Borough" || ' / ' || zpu."Zone" as "pickup_loc",
	zdo."Borough" || ' / ' || zdo."Zone" as "dropoff_loc"
from
	yellow_taxi_trips t,
	zones zpu,
	zones zdo
where
	t."PULocationID" = zpu."LocationID" AND
	t."DOLocationID" = zdo."LocationID" 
limit 100;


-- Other way to do join
select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	zpu."Borough" || ' / ' || zpu."Zone" as "pickup_loc",
	zdo."Borough" || ' / ' || zdo."Zone" as "dropoff_loc"
from
	yellow_taxi_trips t
	inner join zones zpu on t."PULocationID" = zpu."LocationID"
	inner join zones zdo on t."DOLocationID" = zdo."LocationID"
limit 100;


-- Check everything is matched

select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	"PULocationID",
	"DOLocationID"
from
	yellow_taxi_trips t
where
	"DOLocationID" not in (
		select "LocationID" from zones )
limit 100;

-- Check no nulls
select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	"PULocationID",
	"DOLocationID"
from
	yellow_taxi_trips t
where
	"PULocationID" is NULL
limit 100;

-- ways to get the day
select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	DATE_TRUNC('DAY', tpep_dropoff_datetime),
	CAST(tpep_dropoff_datetime as DATE),
	total_amount
from
	yellow_taxi_trips t
limit 100;

-- group by
select
	cast(tpep_dropoff_datetime as DATE) as "day",
	count(1) as records, 
	sum(total_amount) as "sum"
from
	yellow_taxi_trips t
group by 
	cast(tpep_dropoff_datetime as DATE)
order by 
	"day" asc;

-- more group by 
select
	cast(tpep_dropoff_datetime as DATE) as "day",
	count(1) as records, 
	max(total_amount) as max_fare,
	max(passenger_count) as max_passengers,
	sum(total_amount) as "sum"
from
	yellow_taxi_trips t
group by 
	cast(tpep_dropoff_datetime as DATE)
order by 
	"records" desc;

-- mind blown! can group by argumen number
select
	cast(tpep_dropoff_datetime as DATE) as "day",
	"DOLocationID",
	count(1) as records, 
	max(total_amount) as max_fare,
	max(passenger_count) as max_passengers,
	sum(total_amount) as "sum"
from
	yellow_taxi_trips t
group by 
	1, 2
order by 
	"records" desc;

-- more practice
select
	cast(tpep_dropoff_datetime as DATE) as "day",
	"DOLocationID",
	count(1) as records, 
	max(total_amount) as max_fare,
	max(passenger_count) as max_passengers,
	sum(total_amount) as "sum"
from
	yellow_taxi_trips t
group by 
	1, 2
order by 
	"day" asc,
	"DOLocationID" asc;
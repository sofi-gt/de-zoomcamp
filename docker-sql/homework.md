# DE-Zoomcamp: Week 1 Homework
- Date: 2022-01-22
- By: Sofi GS :wave:


In this homework we'll prepare the environment 
and practice with terraform and SQL

## Question 1. Google Cloud SDK

Install Google Cloud SDK. What's the version you have? 

To get the version, run `gcloud --version`

```bash
gcloud --version
```

**Answer:**
```bash
Google Cloud SDK 369.0.0
bq 2.0.72
core 2022.01.14
gsutil 5.6
```

## Google Cloud account 

Create an account in Google Cloud and create a project.


## Question 2. Terraform 

Now install terraform and go to the terraform directory (`week_1_basics_n_setup/1_terraform_gcp/terraform`)

After that, run

* `terraform init`
* `terraform plan`
* `terraform apply` 

Apply the plan and copy the output to the form

**Answer:**
```bash
google_bigquery_dataset.dataset: Creating...
google_storage_bucket.data-lake-bucket: Creating...
google_storage_bucket.data-lake-bucket: Creation complete after 1s [id=dtc_data_lake_phrasal-pad-338818]
google_bigquery_dataset.dataset: Creation complete after 1s [id=projects/phrasal-pad-338818/datasets/trips_data_all]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```


## Prepare Postgres 

Run Postgres and load data as shown in the videos

We'll use the yellow taxi trips from January 2021:

```bash
wget https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv
```

Download this data and put it to Postgres

## Question 3. Count records 

How many taxi trips were there on January 15?

```sql
select 
	count(1)
from 
	yellow_taxi_trips
where 
	extract(year from tpep_pickup_datetime) = 2021
	and extract(month from tpep_pickup_datetime) = 1
	and extract(day from tpep_pickup_datetime) = 15;
```

**Answer:** 53024

## Question 4. Average

Find the largest tip for each day. 
On which day it was the largest tip in January? 

(note: it's not a typo, it's "tip", not "trip")
```sql
select 
	cast(tpep_pickup_datetime as Date) as "date",
	max(tip_amount) as tip
from 
	yellow_taxi_trips
where 
	extract(year from tpep_pickup_datetime) = 2021
	and extract(month from tpep_pickup_datetime) = 1
group by 
	1
order by 
	tip desc
limit 5;

```

**Answer:** January 20



## Question 5. Most popular destination

What was the most popular destination for passengers picked up 
in central park on January 14?

Enter the district name (not id) 

```sql
select 
	"PULocationID",
	zpu."Zone" as pickup_borough,
	zdo."Zone" as dropoff_borough,
	count(1) as trips
from 
	yellow_taxi_trips t
	join zones zpu on t."PULocationID" = zpu."LocationID"
	join zones zdo on t."DOLocationID" = zdo."LocationID"
where zpu."Zone" = 'Central Park'
	and extract(day from tpep_pickup_datetime) = 14
group by 
	1, 2, 3
order by 
	trips desc
limit 5;

```

**Answer:** Upper East Side South


## Question 6. 

What's the pickup-dropoff pair with the largest 
average price for a ride (calculated based on `total_amount`)?

```sql
select 
	"PULocationID" || '-' || "DOLocationID" as id_pair,
	zpu."Borough" || '-' || zdo."Borough" as borough_pair,
	zpu."Zone" as pickup_zone,
	zdo."Zone" as dropoff_zone,
	avg(total_amount) as average_price
from 
	yellow_taxi_trips t
	join zones zpu on t."PULocationID" = zpu."LocationID"
	join zones zdo on t."DOLocationID" = zdo."LocationID"
group by 
	1, 2, 3, 4
order by 
	average_price desc
limit 5;

```

**Answer:**  "Alphabet City" / "Unknown"


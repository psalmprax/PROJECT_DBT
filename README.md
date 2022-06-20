# Data Engineering Task: Using the Airflow and DBT with Docker Compose

This solution tends to implement data modeling using dbt and airflow.

## Authors

- [@psalmprax](https://www.github.com/psalmprax)

## Setup
1) To setup the project, use need to install docker and docker-compose in your virtual machine :

```bash
$ docker-compose up --build -d
```

2) Before running the jobs, the source database and the target database must be setup in the airflow connection ui
using the postgres provider

```bash
	Connection Id: target	
	Connection Type: Postgres
	Host: postgres_target
	Schema: target	
	Login: target
	Password: target
	Port: 5432
	```
	```bash
	Connection Id: source	
	Connection Type: Postgres
	Host: postgres_source
	Schema: source	
	Login: source
	Password: source
	Port: 5432
```
3) The Airflow dag has 4 jobs. Run the job in the order that they are listed below
```bash
	- T-dbt-job-cdc_load
	- T-dbt-job-objects 
	- T-dbt-job-dimensions
	- T-dbt-job-facts
```

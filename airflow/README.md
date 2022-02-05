# Set up credentials
The Google Service account credentials should be named `google-credentials.json` and store in the following way:

```bash
~/.google/credentials/google-credentials.json
```


# Download official airflow docker-compose file

Create an airflow folder and download the following file:
```bash
mkdir airflow
cd ./airflow
```

```bash
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
```

This is the official startup template. It may have more services that you will need for your project and it can be edited.

# Set up Airflow user

Create a `.env` file in the same folder as the `docker-compose.yaml` file.

```bash
cd ./airflow
touch .env
```

On MacOS add `AIRFLOW_UID=50000` to the file:

```bash
echo -e "AIRFLOW_UID=50000" > .env 
```

# Create empty directories

In the airflow directory, create `dags` , `logs` and `plugins` sub-directories.

```bash
mkdir -p ./dags ./logs ./plugins
```

* dags: will store the airflow pipelines.
* logs: stores all the log information between the Scheduler and the Workers.
* plugins: stores any extra plugins, functions and utilities that you will need within your DAG.

# Requirements file

Create a `requirements.txt` file where we will have all of the libraries needed for the project.
```bash
touch requeriments.txt
```
Add the following text to the file:

```
apache-airflow-providers-google
pyarrow
```

# Docker Build

We will use an extended image to allow the local airflow environment to interact with the GCP environment. For that we need to modify the `docker-compose.yaml` file.

Remove the following line from `docker-compose.yaml`

```yaml
image: ${AIRFLOW_IMAGE_NAME:-apache/airflow:2.2.3}
```

Uncomment the `build` line and add the following:

```yaml
  build: 
    context: .
    dockerfile: ./Dockerfile
```

In the `airflow` directory, create a `Dockerfile`

```bash
touch Dockerfile
```

In the Dockerfile add the `apache/`airflow` image that appeared in the yaml configuration file. 

```DOCKER
FROM apache/airflow:2.2.3
```

Configure the `Dockerfile` to add `gcloud` and other packages needed for the project.
Here is the final [`Dockerfile`](https://github.com/sofi-gt/de-zoomcamp/blob/main/airflow/Dockerfile)

In the `docker-compose.yaml` you can stop the loading of airflow examples changing `AIRFLOW__CORE__LOAD_EXAMPLES` to `false`

```yaml
AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
```

# Build the docker image

In the `airflow` directory where you have the docker-compose.yaml file

```bash
docker-compose build
```

The build may take 15-20 minutes for the first time..
You will only need to run the build command whenever there is a change in the `Dockerfile`

# Initialize service

```bash
docker-compose up airflow-init
```
After the initialization it should finish with success code 0.

Then we can kick-up all the other services in the container including the backend and the workers.
```bash
docker-compose up
```

# Open airflow

When the webservice is running and healthy go to `0.0.0.0:8080` in your browser.


# Creating our data pipeline

## Workflow components
Directed Acyclic Graph (DAG): specifies the dependencies between tasks with explicit execution order. It has a beginning and an end.

Task: defined unit of work. In airflow they are known as operators. They describe what to do. Ex: Fetch data, triggering other systems, etc.

DAG run: initial execution and run of DAG.

Task instance: individual run of a single task. They have a indicador state such as running, success, failed.

## Airflow DAG
Is a python file composed of :
 * DAG definition
 * Tasks (operators)
 * Tasks dependencies

 ### DAG declaration
 Can be done in an implicit way using a context manager

 ```python
with DAG(
    dag_id="data_ingestion_gcs_dag",
    schedule_interval="@daily",
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=['dtc-de'],
) as dag:
    ....
 ```
There are other ways to declare a DAG such as a standard constructur. You pass the DAG to a task such as operator or you add a DAG decorator to turn a function into a DAG generator.

 Tasks will come in forms as operators, sensors or taskflow.

 A DAG runs with a series of tasks 
 operators predefined tasks that you can string together quickly to build most parts of your DAG.
 Sensors: special subclass of operators that are used to wait for an external event to happen. 
 TaskFlow decorators: special python functions packaged up as tasks.

 these are all subclassed of airflows base operator. Sometimes tasks and operators are interchangeable.

 We will operators from official providers such as `airflow.providers.google.cloud.operators.bigquery` or with customed defined python functions.
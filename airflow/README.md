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
# Airflow demo: Using the DockerOperator with Docker Compose

Most of tutorials just explains how to use the [Airflow DockerOperator](https://airflow.apache.org/docs/apache-airflow-providers-docker/stable/_api/airflow/providers/docker/operators/docker/index.html) using the bare metal installation; and here we will use it with [Airflow on top of Docker Compose](https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html).

## Authors

- [@fclesio](https://www.github.com/fclesio)

## Setup
1) First create a container with the webservice and create the `airflow` user, [as described in the official docs](https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html):

```bash
$ docker-compose up airflow-init
```

or execute the following script below:
```bash
$ bash bin/initial_setup.sh
```

2) With this initial setup made, start the webservice and other components via `docker-compose`, 

```bash
$ docker build -f dags/docker_job/Dockerfile -t docker_image_task . && \
docker-compose up -d
```

or execute the following script below that will do the same thing:
```bash
$ bash bin/start.sh
```

3) Finally when you're done with your experiment, stop all containers running the following command:
```bash
$  bash bin/stop.sh
```
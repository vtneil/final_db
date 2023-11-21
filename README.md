# FinaleGres

(Docker broken, use existing database and run sql files)

**!!!see `create_table.sql` for References!!!**

PostgreSQL database for the Final Project of Database Systems.

This repository provides a Dockerized PostgreSQL database with pre-defined credentials. It includes a sample SQL script (`demo_ins_upd_del.sql`) to set up tables and sample data.


<details>
  <summary><strong>Table of Contents</strong></summary>

- [FinaleGres](#finalegres)
  - [Usage](#usage)
  - [Environment Variables](#environment-variables)
  - [Connecting to the Database](#connecting-to-the-database)
  - [Docker Hub](#docker-hub)
  - [With Pdadmin4 Container](#with-pdadmin4-container)
    - [Prerequisites](#prerequisites)
    - [Steps](#steps)
  - [Issues](#issues)
  - [Special Thanks](#special-thanks)

</details>


## Usage
1. Clone the repository to your local machine:
```bash
git clone https://github.com/HEKYPTO/FinaleGres.git
cd FinaleGres
```
2. Build the Docker Image and Run the Docker Container

```bash
docker build -t mygres .
docker run -d -p 5432:5432 --name mygres-container --rm mygres
```

## Environment Variables

The following environment variables are set within the Dockerfile:

```bash
POSTGRES_DB: Database name (default: admin)
POSTGRES_USER: PostgreSQL user (default: admin)
POSTGRES_PASSWORD: PostgreSQL password (default: admin)
```
These can be customized by updating the respective ENV lines in the Dockerfile.

## Connecting to the Database
You can connect to the PostgreSQL database using the provided credentials:

```txt
Host: localhost
Port: 5432
Database: admin
User: admin
Password: admin
```

Thank you for exploring the FinalGres PostgreSQL database! If you have any questions, encounter issues, or want to contribute, feel free to open an issue or pull request. Best of luck with your Database Systems Final Project!

## Docker Hub
For more details, you can also visit the [Docker Hub repository](https://hub.docker.com/repository/docker/tsunnami/finalegres/general).

## With Pdadmin4 Container

### Prerequisites

Ensure you have Docker and Docker Compose installed on your machine.

### Steps

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/HEKYPTO/FinaleGres.git
    cd FinaleGres
    ```

2. Run the following command to start the containers:

    ```bash
    docker-compose up -d
    ```

    This will pull the necessary Docker images and create the containers.

    **If it doesn't allow connection**:
    Pull image to your local machine first

    ```bash
    docker pull tsunnami/finalegres:latest
    ```

3. Wait for the containers to start.

4. Access pgAdmin4 in your web browser at [http://localhost:8888](http://localhost:8888).

5. Log in with the default credentials:

    ```txt
    PGADMIN_DEFAULT_EMAIL: admin@admin.com
    PGADMIN_DEFAULT_PASSWORD: admin
    ```

6. In pgAdmin4, add a new server to connect to the PostgreSQL container using the following connection details:

    ```txt
    Name: /*Anything you want*/
    Hostname/address: mygres
    Port: 5432
    Username: admin
    Password: admin
    ```

Now, you have a running PostgreSQL database with pgAdmin4 for easy database management through a web interface.

**Note**: Ensure that the containers are running and accessible before attempting to connect to pgAdmin4.

## Issues

If you encounter any issues or have questions, feel free to open an issue or reach out for assistance.

- If connection refuse to pull mygres from using `docker-compose.yml` => pull the image from docker-hub manually to your local machine. Then docker-compose command should works normally
- Naming conflict, I have updated the name of pgadmin4 to not conflict with the existing name (should not comflict "maybe?")

## Special Thanks

A special thanks to [vishal.sharma](https://medium.com/@vishal.sharma.) for providing an insightful guide on running PostgreSQL and PGAdmin using Docker Compose. The guide, available on [Medium](https://medium.com/@vishal.sharma./run-postgresql-and-pgadmin-using-docker-compose-34120618bcf9), has been invaluable in understanding and setting up our project.

Your contribution to the community and the clarity of your guide have greatly benefited our project. Thank you for sharing your expertise!

If you've contributed to FinaleGres in any way, even if it's just raising an issue or providing feedback, thank you for being part of this project!

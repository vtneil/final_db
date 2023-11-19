# FinaleGres

**!!!see `Table.sql` for Refernces!!!**

PostgreSQL database for the Final Project of Database Systems.

This repository provides a Dockerized PostgreSQL database with pre-defined credentials. It includes a sample SQL script (`TableCommand.sql`) to set up tables and sample data.

## Usage

#### Build the Docker Image and Run the Docker Container

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

## PS
I will reorganize file structure when I have time <3
# Use an official PostgreSQL image as the base image
FROM postgres:latest

# Set the environment variables
ENV POSTGRES_DB=admin
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin

# Add your SQL script and CSV files to the docker-entrypoint-initdb.d/ directory
COPY TableCommand.sql /docker-entrypoint-initdb.d/
COPY data/*.csv /docker-entrypoint-initdb.d/ 

# Expose the PostgreSQL port (not necessary if you're running in the default network mode)
EXPOSE 5432

# Start the PostgreSQL service (CMD is provided by the official image)
CMD ["postgres"]
# docker build -t mygres .
# docker run -d -p 5432:5432 --name mygres-container mygres
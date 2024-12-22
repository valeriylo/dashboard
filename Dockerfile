FROM mysql:latest

# Copy the initialization script into the container
COPY init_db.sh /docker-entrypoint-initdb.d/

# Copy HH_data_DA.csv to docker-container
COPY ./data/HH_data_DA.csv /var/lib/mysql-files/data.csv

# Make sure the script is executable
RUN chmod +x /docker-entrypoint-initdb.d/init_db.sh
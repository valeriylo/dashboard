# Define a log file path
CONTAINER_LOG_FILE="./mysql-container.log"

# Run the Docker container
docker run \
  -d \
  --rm \
  --name mysql-container \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=mydatabase \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=admin \
  mysql \
  --secure-file-priv=/var/lib/mysql-files/

# Wait for the container to start
sleep 5

# Redirect container logs to a file
docker logs -f mysql-container > "$CONTAINER_LOG_FILE" 2>&1 &
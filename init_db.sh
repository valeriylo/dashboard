#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Wait for MySQL to start
echo "WAITING FOR MYSQL TO START..."
sleep 10  # Adjust this time if necessary

# Create database and table with admin privileges
mysql -u"root" -p"$MYSQL_ROOT_PASSWORD" -e "
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
USE $MYSQL_DATABASE;
CREATE TABLE IF NOT EXISTS job_vacancies (
    archived INT,
    area_name VARCHAR(255),
    direction VARCHAR(50),
    employer_name VARCHAR(255),
    level VARCHAR(50),
    name VARCHAR(255),
    published_at DATETIME,
    url VARCHAR(255),
    vacancy_id INT,
    employer_id INT,
    salary_from DECIMAL(10, 2) DEFAULT NULL,
    salary_to DECIMAL(10, 2) DEFAULT NULL,
    salary_gross_flag TINYINT(1),
    query_string TEXT,
    type VARCHAR(50),
    Lat DECIMAL(9, 6),
    Lng DECIMAL(9, 6),
    salary_net DECIMAL(10, 2)
);"

echo "DATABASE AND TABLE CREATED SUCCESSFULLY."

# Load data.csv into the table with admin privileges
mysql -u"root" -p"$MYSQL_ROOT_PASSWORD" -e "
USE mydatabase;
SET sql_mode = '';
LOAD DATA INFILE '/var/lib/mysql-files/data.csv'
INTO TABLE job_vacancies
FIELDS TERMINATED BY ';'
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@archived, @area_name, @direction, @employer_name, @level, @name, @published_at, @url, @vacancy_id, @employer_id, @salary_from, @salary_to, @salary_gross_flag, @query_string, @type, @Lat, @Lng, @salary_net)
SET 
archived = @archived,
area_name = @area_name,
direction = @direction,
employer_name = @employer_name,
level = @level,
name = @name,
published_at = STR_TO_DATE(@published_at, '%d.%m.%Y %H:%i:%s'),
url = @url,
vacancy_id = @vacancy_id,
employer_id = @employer_id,
salary_from = @salary_from,
salary_to = @salary_to,
salary_gross_flag = @salary_gross_flag,
query_string = @query_string,
type = @type,
Lat = @Lat,
Lng = @Lng,
salary_net = @salary_net;
"
echo "DATA LOADED SUCCESSFULLY."

echo "DUMPING DB TO SQL FILE..."
mysqldump -u"root" -p"$MYSQL_ROOT_PASSWORD" $MYSQL_DATABASE > /var/lib/mysql-files/mydatabase.sql

echo "DONE"

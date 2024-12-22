import mysql.connector
import matplotlib.pyplot as plt
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

def connect_to_database():
    # Connect to the MySQL database in Docker using environment variables
    connection = mysql.connector.connect(
        host=os.getenv('MYSQL_HOST'),
        port=int(os.getenv('MYSQL_PORT')),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        database=os.getenv('MYSQL_DATABASE')
    )
    return connection

def fetch_data(connection):
    cursor = connection.cursor()
    query = """
    SELECT direction, COUNT(*) as direction_count
    FROM job_vacancies
    GROUP BY direction;
    """
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    return result

def plot_data(data):
    categories = [row[0] for row in data]
    counts = [row[1] for row in data]

    plt.figure(figsize=(10, 6))
    plt.bar(categories, counts, color='skyblue')
    plt.xlabel('Category')
    plt.ylabel('Number of Directories')
    plt.title('Number of Directories per Category in Job Vacancy')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()

    plt.savefig('./results/directory_count.png')

def main():
    connection = connect_to_database()
    try:
        data = fetch_data(connection)
        plot_data(data)
    finally:
        connection.close()

if __name__ == "__main__":
    main()

import json
import requests
import mysql.connector
from mysql.connector import Error
from datetime import datetime

def mysql_connection(host_name, user_name, user_password, db_name, port=3306):
    connection = None
    try:
        connection = mysql.connector.connect(
            host = host_name,
            user = user_name,
            password = user_password,
            database = db_name,
            port = port
        )
        print("Connection to MYSQL DB sucessful")
    except Error as e:
        print(f"Exception {e} ocurred")
    return connection

def insert_data(connection, data):
    cursor = connection.cursor()
    query = "INSERT INTO monitor_data (name,step_name,step_status,curr_time) VALUES (%s,%s,%s,%s)"
    try:
        cursor.execute(query, data)
        connection.commit()
        print("Data inserted successfully")
    except Error as e:
        print(f"Exception {e}")

if __name__ == "__main__":

    db_conn = mysql_connection("mysql","monitor","S6jdPy^m$J!ag7$yCFbee@m$","tobeit","3306")

    url = "https://dev.elastic.tobeit.net/synthetics-browser-default/_search"

    headers = {
        'kbn-xsrf': 'reporting',
        'Authorization': 'Basic dG9iZWl0LnRlc3Q6IVJAbmRvbS41Njch',
    }

    curr_time = datetime.now()
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        #print(data.get('hits',[]))
        for hit in data.get('hits',[]).get('hits',[]):
            monitor_name = hit['_source']['monitor']['name']
            step_value = hit['_source'].get('synthetics', {}).get('step')

            if step_value is not None:
                step_name = hit['_source']['synthetics']['step']['name']
                step_status = hit['_source']['synthetics']['step']['status']
            else:
                step_name = 'None'
                step_status = 'None'

            data = []
            data.extend([monitor_name,step_name,step_status,curr_time])
            insert_data(db_conn,data)

    else:
            print(f"Failed to retrieve data, HTTP Status: {response.status_code}")
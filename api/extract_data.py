from app import app
import pandas as pd
from sodapy import Socrata
from db_connection import create_connection, execute_query
import logging
import os

def save_data_to_db(data, engine):
    results_df = pd.DataFrame.from_dict(data, dtype=str)
    results_df['audit_date'] = pd.Timestamp("now")
    results_df.to_sql('fire_incidents', con=engine, schema='data_bronze', if_exists="append", index=False)

def get_max_extraction_date(connection):
    my_query = 'SELECT MAX(data_loaded_at) AS max_rawdata FROM data_bronze.fire_incidents'
    try:
        results = execute_query(connection, my_query)
        max_date = results[0][0]
    except:
        max_date = None
    return max_date

def extract_data():
    host = os.environ['POSTGRES_HOST']
    port = os.environ['POSTGRES_PORT']
    user = os.environ['POSTGRES_USER']
    password = os.environ['POSTGRES_PASSWORD']
    database = os.environ['POSTGRES_DB']
    #Query to get max_date from table
    engine, connection = create_connection(host, port, user, password, database)
    max_date = get_max_extraction_date(connection)
    
    #If table has data, extracts from last date loaded
    if max_date:
        where_query = f"data_loaded_at > '{max_date}'"
    else:
        where_query = "1 = 1"

    #Start client connection
    client = Socrata("data.sfgov.org", None)

    #Iterate over new records until no records found
    offset = 0
    results = -1
    total_results = 0
    while results != 0:
        data = client.get("wr8u-xric", limit=50000, offset=offset, where=where_query, order='data_loaded_at ASC')
        results = len(data)
        total_results += results
        app.logger.info(f'{total_results} records read')
        # Convert to pandas DataFrame and save to postgres database
        save_data_to_db(data, engine)
        app.logger.info(f'{total_results} records written to db')
        offset += results

    return total_results

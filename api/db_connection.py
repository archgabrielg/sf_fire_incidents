from sqlalchemy import create_engine, text

def create_connection(host, port, user, password, database):
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{database}')
    connection = engine.connect()
    return engine, connection

def execute_query(connection, query):
    results = connection.execute(text(query)).fetchall()
    return results
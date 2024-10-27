# San Francisco Fire incidents Challenge

## Introduction

Welcome to **San Francisco fire incidents analysis**! This project aims to give a end to end solution for processing San Francisco fire incidents from a  [DataSF Public Dataset](https://data.sfgov.org/Public-Safety/Fire-Incidents/wr8u-xric)

## Description

### Components

1. **Postgres Database**
   - **Description**: 
        - This component creates a postgres database that will serve as our data warehouse in this solution
        - The component will be deployed as a docker container and initialized by docker-compose


2. **Process Data API**
   - **Description**:
        - This component provides python scripts connect to our source dataset via its API, download the data and upload it to our postgres database
        - The component will be provided as a simple flask API for ease of use
        - The component will be deployed as a docker container and initalized by docker-compose

3. **dbt project**
   - **Description**: 
        - This component includes a **challenge** dbt project that will process our fire incidents data through silver and gold layers
        - Includes a silver layer where last data will be loaded and cleansed
        - Includes a gold layer where data will be loaded as a star schema for report consumption
        - The component will be deployed as a docker container and ran at demand

3. **PBI report**
   - **Description**: 
        - A .pbix report is included in this project with some sample reports of fire incidents in San Francisco
        - The report connects to the gold schema through localhost

## Usage

To get started, follow these steps:

1. **Pre-requisites**: You need Docker and python 3.X installed on your PC. You will also need PowerBI Desktop to visualize the pbix dashboard

2. **Installation**:
   - Clone this repo
   ```bash
   git clone https://github.com/archgabrielg/sf_fire_incidents.git
   ```
   - If needed, you can change environment variables in .env file

3. **Initalization**:

   - Build docker images
   ```bash
   docker build -t db-postgres ./db
   docker build -t api-extract ./api
   docker build -t dbt-challenge ./dbt
   ```

   - Initialize the Postgres DB and the Flask API through docker-compose
   ```bash
   docker compose up
   ```

4. **Process data**:

   - Call flask API to process data (**Note**: This can take a few minutes to load the whole dataset)
   ```bash
   curl http://localhost:5000/extract
   ```

   - Once data is loaded, run dbt to process data (**Note**: if your current directory is different from **sf_fire_incidents**, you might need to change the network with your current directory name)
   ```bash
   docker run --network sf_fire_incidents_network-challenge --env-file ./.env dbt-challenge run
   ```
*
   - Optionally, you can also run dbt test to check data consistency (**Note**: if your current directory is different from **sf_fire_incidents**, you might need to change the network with your current directory name)
   ```bash
   docker run --network sf_fire_incidents_network-challenge --env-file ./.env dbt-challenge test
   ```

4. **Visualize data**:

   - Open the San Francisco Fire incidentes report.pbix and refresh the data, you will need to provide the user and password set up in .env file. Additionally, if you changed an env parameter you will need to change it in the Power Query editor


## Assumptions and considerations

For this project we assume the following:
   - Dataset is fully refreshed each day, with the same value for all records on the **data_loaded_at** field
   - Primary key of the dataset is the conjunction of incident number and expose number
   - Components are loaded with docker for ease of use and to provide intercompatibility between different OS and systems

Additionally, the data is stored and processed in a medallion architecture, where each layer in the database will contain:
- Bronze (**data_bronze**)
    - Will contain rawdata coming from the dataset, maintaining previous days history in case of need
    - All data will be loaded as string and casted in the following layers
- Silver (**data_silver**)
    - Will contain only the last information of the dataset, filtering by the greatest value on **data_loaded_at**
    - The data in this layer will be cleansed, contain its corresponding datatype and fields that include a code and description will be split into two
    - Data in this layer will only be views
- Gold (**gold_layer**)
    - Data in this layer will be stored in a star schema, with a fact table of fire incidents and different dimensions.
    - Only "city", "district", "battalion" and "time" divisions are created since no more info is used in the report, but additional dimension can be created if needed
    - Only data in this layer will be consumed by the PBI report
    - Data in this layer will be stored as tables in the database
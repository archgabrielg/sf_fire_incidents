FROM python:3.9

RUN apt-get update \
    && apt-get install -y --no-install-recommends

WORKDIR /app

RUN mkdir -p /root/.dbt

COPY ./challenge /app

COPY profiles.yml /root/.dbt/profiles.yml

RUN pip install --upgrade pip
RUN pip install dbt-core dbt-postgres --no-cache-dir
RUN dbt deps

EXPOSE 8080

ENTRYPOINT ["dbt"]

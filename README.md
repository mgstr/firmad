# Firmad
PostgreSQL database with a list of companies registered in Estonia.

Free open data can be downloaded from [Avaandmete portaal](https://opendata.riik.ee/dataset/http-avaandmed-rik-ee-andmed-ariregister) in the form of [compressed CSV file](http://avaandmed.rik.ee/andmed/ARIREGISTER/ariregister_csv.zip).

This project converts this data into PostgreSQL database that is provided as a Docker image for easy consumption. It also adds full text search capabilities to search company data by name, address or location.

## Image creation

Run `create.sh` to generate a docker image with data and push it into `mgstr\firmad` Docker repository.

IMPORTANT: comment last 4 lines of script if you only want to consume image locally.

## Container usage

You can consume the container by running it:

     docker run -d --name firmad-test mgstr/firmad

Access to the PostgreSQL database is done using default [PostgreSQL image](https://hub.docker.com/_/postgres/) 'postgres:password' credentials.
So for *playing* with database just attach to the running container:

     docker exec -it firmad-test /bin/bash

and run psql:

     PGPASSWORD=password psql -U postgres

and run sql statements:

     select * from company limit 3;

## Tables

### company

    create table company (
        name text,
        id integer primary key,
        kmkr text,
        state text,
        address text,
        location_code text,
        location_text text,
        location_index text,
        ft tsvector -- helper column for full text search
    );

## Functions

### find_company

Find company using full text search on name, address and location. Show only first 10 results that match query.

`select * from find_company('hell');`

|        name        |    id    |    kmkr     |       state        |   address   | location_code |             location_text              | location_index |
|--------------------|----------|-------------|--------------------|-------------|---------------|----------------------------------------|----------------|
| Hell Käsi OÜ       | 11671944 |             | Registrisse kantud | Alliku talu | 1018          | Aakre küla, Puka vald, Valgamaa        | 67202          |
| Osaühing Hell-Mari | 10334216 |             | Likvideerimisel    | Liiva 8     | 0349          | Kuressaare                             | EE3300         |
| OÜ Hell Dog        | 12259499 | EE101529655 | Registrisse kantud | Puksa talu  | 8574          | Tännassilma küla, Põlva vald, Põlvamaa | 63224          |

### count_companies

count number of companies that match query

`select * from count_companies('kalev');`

      count_companies 
     -----------------
                  188
     (1 row)

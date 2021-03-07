#!/bin/bash

set -e
set -u

function create_hydra_database() {
	local database=$1
	export PGPASSWORD="$POSTGRES_PASSWORD"
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL 
	    CREATE USER $database;
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
			\c $database;
			CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $database;			
EOSQL
}

function create_flights_database() {
	local database=$1
	export PGPASSWORD="$POSTGRES_PASSWORD"
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL 
	    CREATE USER $database;
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
			\c $database;
			CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $database;
			CREATE EXTENSION IF NOT EXISTS postgis;
			CREATE TABLE Flights (
			  id SERIAL PRIMARY KEY,
			  geom GEOMETRY(Point, 4326),
			  latitude decimal,
			  longitude decimal,
			  country VARCHAR(128),
			  call_sign VARCHAR(128),
			  icao VARCHAR(128),
			  velocity decimal
			);			
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		# we need different scripts to create the databases, flights should store the live flights and hydra the users information
	
		if [ $db = "hydra" ]; then
			create_hydra_database $db &
		fi		
		
		if [ $db = "flights" ]; then
			create_flights_database $db &
		fi	
	done
	
	# since the databases are being created in different processes (&) we need to wait for them to finish
	wait
	echo "Multiple databases created"
fi
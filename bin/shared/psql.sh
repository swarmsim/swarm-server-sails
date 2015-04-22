#!/bin/sh -eux
cd "`dirname "$0"`/../.."
. ./bin/shared/shared.sh
exportenv "$@"
PGPASSFILE=secrets/pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -d "dbname=$POSTGRES_DB sslmode=verify-full sslrootcert=config/rds-combined-ca-bundle.pem" -U $POSTGRES_USER -w

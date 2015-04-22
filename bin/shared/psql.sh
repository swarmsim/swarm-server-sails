#!/bin/sh -eux
cd "`dirname "$0"`/../.."
. ./bin/shared/shared.sh
exportenv "$@"
PGPASSFILE=secrets/pgpass psql -h $POSTGRES_HOST -p $POSTGRES_PORT -d $POSTGRES_DB -U $POSTGRES_USER -w

#!/bin/sh -eux
cd "`dirname "$0"`/../.."
. ./bin/shared/shared.sh
exportenv "$@"
# http://www.postgresql.org/docs/8.4/static/libpq-envars.html
# "Use of [the $PGPASS] environment variable is not recommended for security reasons (some operating systems allow non-root users to see process environment variables via ps);"
# I'm already relying on environment variables for passwords/etc, so in this case we're already hosed. No plans to change this; my dev machine is secure. Careful developing on shared hosting.
PGPASSWORD="$POSTGRES_PASSWORD" psql -h $POSTGRES_HOST -p $POSTGRES_PORT -d "dbname=$POSTGRES_DB sslmode=verify-full sslrootcert=config/rds-combined-ca-bundle.pem" -U $POSTGRES_USER -w


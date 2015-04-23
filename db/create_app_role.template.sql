-- Create the user the server connects with, granted minimal permissions.
-- Populate this file with `envsubst`. It has a password - don't commit the output!
-- This will be re-run when the password changes, and should succeed if the user already exists.

revoke all on all tables in schema public from $POSTGRES_USER;
revoke all on all sequences in schema public from $POSTGRES_USER;
--drop role if exists $POSTGRES_USER;

-- this may output an error if the user exists - but dropping an existing user
-- causes downtime, and there's no 'create if not exists'
create role $POSTGRES_USER;

alter role $POSTGRES_USER with
password '$POSTGRES_PASSWORD'
login;

-- no true deletes, for now
grant select, insert, update
on all tables in schema public
to $POSTGRES_USER;
grant all
on all sequences in schema public
to $POSTGRES_USER;

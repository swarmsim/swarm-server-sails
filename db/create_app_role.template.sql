-- this may output an error if the user exists - but dropping an existing user
-- causes downtime, and there's no 'create if not exists'
create role $POSTGRES_USER;

begin transaction;
-- Create the user the server connects with, granted minimal permissions.
-- Populate this file with `envsubst`. It has a password - don't commit the output!
-- This will be re-run when the password changes, and should succeed if the user already exists.

revoke all on all tables in schema public from $POSTGRES_USER;
revoke all on all sequences in schema public from $POSTGRES_USER;
revoke select, insert, update (username, email, id, "createdAt", "updatedAt", "role") on "user" from $POSTGRES_USER;
--drop role if exists $POSTGRES_USER;

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
-- all tables and columns, except user.role (isAdmin)
-- https://stackoverflow.com/questions/3281706/postgresql-disallow-the-update-of-a-column-how
-- https://dba.stackexchange.com/questions/22362/how-do-i-list-all-columns-for-a-specified-table
revoke insert, update
on "user"
from $POSTGRES_USER;
-- subselect + grant fails, dang.
--  (SELECT column_name
--  FROM information_schema.columns
--  WHERE table_schema = 'public'
--    AND table_name   = 'user'
--    AND column_name != 'role')
grant select, insert, update
(username, email, id, options, "createdAt", "updatedAt") on "user"
to $POSTGRES_USER;
-- command is append-only
revoke update
on "command"
from $POSTGRES_USER;

commit transaction;

'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
BEGIN;

ALTER TABLE passport
ADD CONSTRAINT passport_user_fkey
FOREIGN KEY ("user")
REFERENCES "user";

CREATE INDEX passport_user_idx ON passport ("user");

ALTER TABLE character
ADD CONSTRAINT character_user_fkey
FOREIGN KEY ("user")
REFERENCES "user";

CREATE INDEX character_user_idx ON character ("user");

COMMIT;
"""
  
exports.down = (knex, Promise) ->
  knex.raw """
DROP INDEX IF EXISTS character_user_idx;
ALTER TABLE character DROP CONSTRAINT IF EXISTS character_user_fkey;
DROP INDEX IF EXISTS passport_user_idx;
ALTER TABLE passport DROP CONSTRAINT IF EXISTS passport_user_fkey;
"""

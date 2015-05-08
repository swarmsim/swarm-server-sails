'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
CREATE INDEX CONCURRENTLY character_createdat_idx ON "character" ("createdAt");
"""
  knex.raw """
CREATE INDEX CONCURRENTLY character_updatedat_idx ON "character" ("updatedAt");
"""
  knex.raw """
CREATE INDEX CONCURRENTLY user_createdat_idx ON "user" ("createdAt");
"""
  knex.raw """
CREATE INDEX CONCURRENTLY user_updatedat_idx ON "user" ("updatedAt");
"""
  knex.raw """
CREATE INDEX CONCURRENTLY command_createdat_idx ON "command" ("createdAt");
"""

exports.down = (knex, Promise) ->
  knex.raw """
BEGIN;

DROP INDEX IF EXISTS character_createdat_idx;
DROP INDEX IF EXISTS character_updatedat_idx;
DROP INDEX IF EXISTS user_createdat_idx;
DROP INDEX IF EXISTS user_updatedat_idx;
DROP INDEX IF EXISTS command_createdat_idx;

COMMIT;
"""

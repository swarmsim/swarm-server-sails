'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
BEGIN;

ALTER TABLE "character"
ADD COLUMN "league" text NOT NULL
DEFAULT 'open';

CREATE INDEX character_league_idx ON character ("league");

COMMIT;
"""

exports.down = (knex, Promise) ->
  knex.raw """
DROP INDEX IF EXISTS character_league_idx;
"""
  knex.schema.table 'character', (table) ->
    table.dropColumn 'league'

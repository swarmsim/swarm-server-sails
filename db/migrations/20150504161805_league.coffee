'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
ALTER TABLE "character"
ADD COLUMN "league" text NOT NULL
DEFAULT 'open';
"""

exports.down = (knex, Promise) ->
  knex.schema.table 'character', (table) ->
    table.dropColumn 'league'

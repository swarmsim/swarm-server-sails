'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
ALTER TABLE "user"
ADD COLUMN "role" text NOT NULL
DEFAULT 'user';
"""

exports.down = (knex, Promise) ->
  knex.schema.table 'user', (table) ->
    table.dropColumn 'role'

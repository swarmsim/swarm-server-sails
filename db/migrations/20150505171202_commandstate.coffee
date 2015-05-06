'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
BEGIN;

ALTER TABLE "command"
ADD COLUMN "state" jsonb NOT NULL
DEFAULT '{}';

COMMIT;
"""

exports.down = (knex, Promise) ->
  knex.raw """
BEGIN;

ALTER TABLE "command"
DROP COLUMN "state";

COMMIT;
"""

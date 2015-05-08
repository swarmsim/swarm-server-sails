'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
BEGIN;

ALTER TABLE "user"
ADD COLUMN options jsonb
NOT NULL DEFAULT '{}';

ALTER TABLE "character"
ADD COLUMN options jsonb
NOT NULL DEFAULT '{}';

COMMIT;
"""

exports.down = (knex, Promise) ->
  knex.raw """
BEGIN;

ALTER TABLE "user" DROP COLUMN IF EXISTS "options";
ALTER TABLE "character" DROP COLUMN IF EXISTS "options";

COMMIT;
"""

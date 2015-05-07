'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
BEGIN;
-- commands are immutable
ALTER TABLE "command"
DROP COLUMN IF EXISTS "updatedAt";

DROP INDEX IF EXISTS command_character_idx;
CREATE INDEX command_character_idx ON command ("character", "createdAt");

ANALYZE;

COMMIT;
"""
  
exports.down = (knex, Promise) ->
  knex.raw """
BEGIN;
  
DROP INDEX IF EXISTS command_character_idx;
-- no rolling back the drop-column

COMMIT;
"""

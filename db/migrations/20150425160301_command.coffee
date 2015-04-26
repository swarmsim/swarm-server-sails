'use strict'

exports.up = (knex, Promise) ->
  knex.raw """
BEGIN;

CREATE TABLE "command"
(
  id serial NOT NULL,
  character integer NOT NULL references character,
  body jsonb NOT NULL,
  "createdAt" timestamp with time zone NOT NULL,
  "updatedAt" timestamp with time zone NOT NULL,
  CONSTRAINT command_pkey PRIMARY KEY (id)
);

CREATE INDEX command_character_idx ON command (character);

COMMIT;
"""

exports.down = (knex, Promise) ->
  knex.raw 'DROP INDEX IF EXISTS command_character_idx;'
  knex.schema.dropTable 'command'

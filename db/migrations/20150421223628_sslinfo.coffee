'use strict'

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.SSL
exports.up = (knex, Promise) ->
  knex.raw """
create extension sslinfo;
"""

exports.down = (knex, Promise) ->
  knex.raw """
drop extension sslinfo;
"""

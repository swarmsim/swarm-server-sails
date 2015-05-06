 # CommandController
 #
 # @description :: Server-side logic for managing commands
 # @help        :: See http://links.sailsjs.org/docs/controllers

assert = require 'assert'
shortid = require 'shortid'

withErrorHandler = (res, stepName, next) ->
  (err, result) ->
    # log errors, return 500, and rollback. don't call next.
    # don't show the database error text in the response.
    if err
      # errorId correlates log messages to the user-visible error.
      errorId = shortid.generate()
      sails.log.error 'command create failed', errorId: errorId, stepName: stepName, message: err
      return res.status(500).json error:"database error: #{stepName}. error id '#{errorId}'"
      # don't wait for a response from rollback.
      #return Command.query 'ROLLBACK TRANSACTION;'
      #.exec (err, result) ->
      #  if err
      #    sails.log.error 'command create rollback failed too', stepName, err
    else
      # no error.
      return next err, result

module.exports =
  create: (req, res) ->
    req.checkBody('character').notEmpty().isInt()
    req.checkBody('state').notEmpty()
    req.checkBody('body').notEmpty()
    if (errors=req.validationErrors())
      return res.status(400).json errors:errors
    charId = req.body.character
    state = req.body.state
    commandBody = req.body.body
    sails.log.debug 'start command create', req.body
    # character state is not updated directly - it comes from a view now
    Command.create {character:charId, body:commandBody, state:state}
    .exec withErrorHandler res, 'create command', (err, command) ->
      #return res.json {command: command.id, state: characters[0].state}
      return res.status(201).json {command: {id:command.id}}

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
    # TODO derive state from command and previous-state
    # No transaction support? Seriously???
    Character.update {id: charId, user:req.user.id}, state: state
    .exec withErrorHandler res, 'update character', (err, characters) ->
      assert characters.length <= 1, 'multiple characters updated?!'
      if characters.length == 1
        # Don't write the command log for now - hits the db too hard.
        return res.json {command: {}}
        # No transaction support? Seriously???
        # No transaction support means that, if this fails, character state
        # will be updated but the command that updated it won't exist.
        #Command.create {character:charId, body:commandBody}
        #.exec withErrorHandler res, 'create command', (err, command) ->
        #  #return res.json {command: command.id, state: characters[0].state}
        #  return res.json {command: {id:command.id}}

      else
        # character update updated nothing. extra query to determine why: does the character not exist, or is it not ours?
        sails.log.debug 'command create/character update fail. determining why. char:', charId
        Character.findOne {id:charId}
        .exec withErrorHandler res, 'zero-update query', (err, character) ->
          if character
            sails.log.debug 'command create fail 403'
            return res.status(403).json error:"That's not your character"
          sails.log.debug 'command create fail 404'
          return res.status(404).json error:"That character doesn't exist"

#    # No transaction support? Seriously???
#    query = """
#BEGIN;
#
#UPDATE character SET state = $1
#WHERE id = $2 AND user = $3;
#
#INSERT INTO command (character, body)
#(SELECT $2, $4 FROM character
#JOIN user ON id=$2 AND user=$3
#LIMIT 1);
#
#COMMIT;
#"""
#    Command.query query, [state, charId, req.user.id, commandBody],
#    withErrorHandler res, 'transaction', (err, result) ->
#      return res.json {result: result, state: state}
#      

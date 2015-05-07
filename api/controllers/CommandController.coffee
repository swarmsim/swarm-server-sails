 # CommandController
 #
 # @description :: Server-side logic for managing commands
 # @help        :: See http://links.sailsjs.org/docs/controllers

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

    # Update both command and character state.
    # Character state: easy to query. Command state: verify correctness.
    # This is really really write-heavy - might optimize later to join character-state from commands; slower reads for faster writes.
    #
    # ...no transactions, sails? really?
    # TODO: oops - this maxes out db cpu! try again tomorrow.
    #Command.create {character:charId, body:commandBody, state:state}
    #.exec ErrorHandler.handleError res, 'create command', (command) ->
    # TODO: trigger
    sails.log.debug 'command created, starting character update', req.body
    Character.update {id:charId}, {state:state}
    .exec ErrorHandler.handleError res, 'create command:update character (transaction failed!)', (command) ->
      sails.log.debug 'command character updated ', req.body
      #return res.json {command: command.id, state: characters[0].state}
      return res.status(201).json {command: {id:command.id}}

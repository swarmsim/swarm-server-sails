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
      return res.badRequest errors
    charId = req.body.character
    state = req.body.state
    commandBody = req.body.body
    sails.log.debug 'start command create', req.body

    # Update both command and character state.
    # Character state: easy to query. Command state: verify correctness.
    # This is really really write-heavy - might optimize later to join character-state from commands; slower reads for faster writes.
    #
    # ...no transactions, sails? really?
    # TODO: logging state with every command consumes a lot of disk space. Add random sampling.
    Command.create {character:charId, body:commandBody, state:{}}
    .exec (err, command) ->
      if err then return res.serverError err
      # TODO: trigger
      sails.log.debug 'command created, starting character update', req.body
      Character.update {id:charId}, {state:state}
      .exec (err, command) ->
        if err then return res.serverError err
        sails.log.debug 'command character updated ', req.body
        return res.okCreated {command: {id:command.id}}

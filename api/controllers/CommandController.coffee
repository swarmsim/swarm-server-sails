 # CommandController
 #
 # @description :: Server-side logic for managing commands
 # @help        :: See http://links.sailsjs.org/docs/controllers

assert = require 'assert'

module.exports =
  create: (req, res) ->
    req.checkBody('character').notEmpty().isInt()
    req.checkBody('state').notEmpty()
    charId = req.body.character
    state = req.body.state
    sails.log.debug 'start command create', req.body
    # TODO create command; transaction
    # TODO derive state from command and previous-state
    Character.update {id: charId, user:req.user.id}, state: state
    .exec (err, characters) ->
      if err then return res.status(500).json error:err
      assert characters.length <= 1, 'multiple characters updated?!'
      if characters.length == 1
        # TODO create command before returning; commit transaction
        sails.log.debug 'command create success'
        return res.json {state: state}
      # failure. extra query to determine the error: does the character not exist, or is it not ours?
      sails.log.debug 'command create fail. determining why. char:', charId
      Character.findOne {id:charId}
      .exec (err, character) ->
        if err then return res.status(500).json error:err
        if character
          sails.log.debug 'command create fail 403'
          return res.status(403).json error:"That's not your character"
        sails.log.debug 'command create fail 404'
        return res.status(404).json error:"That character doesn't exist"

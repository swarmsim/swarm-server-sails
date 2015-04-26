 # CharacterController
 #
 # @description :: Server-side logic for managing characters
 # @help        :: See http://links.sailsjs.org/docs/controllers

assert = require 'assert'
module.exports =
  update: (req, res) ->
    req.checkParams('id').notEmpty().isInt()
    if (errors=req.validationErrors())
      return res.status(400).json errors:errors
    Character.update {id:req.params.id, user:req.user.id}, req.body
    .exec (err, characters) ->
      if err then return res.status(500).json error:err
      assert characters.length <= 1, 'multiple characters updated?!'
      if characters.length == 1
        # success! common case.
        return res.json characters[0]
      # failure. extra query to determine the error: does the character not exist, or is it not ours?
      Character.findOne {id:req.params.id}
      .exec (err, character) ->
        if err then return res.status(500).json error:err
        if character
          return res.status(403).json error:"That's not your character"
        return res.status(404).json error:"That character doesn't exist"

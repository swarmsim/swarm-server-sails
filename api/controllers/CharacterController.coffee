 # CharacterController
 #
 # @description :: Server-side logic for managing characters
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  update: (req, res) ->
    req.checkParams('id').notEmpty().isInt()
    req.checkParams('league').isNull()
    if (errors=req.validationErrors())
      return res.badRequest errors
    Character.update {id:req.params.id, user:req.user.id}, req.body
    .exec (err, characters) ->
      if err then return res.serverError err
      if characters.length > 1
        return res.serverError "Multiple characters updated! Expected rowcount 1, got #{characters.length}"
      if characters.length == 1
        # success! common case.
        return res.ok characters[0]
      # failure. extra query to determine the error: does the character not exist, or is it not ours?
      Character.findOne {id:req.params.id}
      .exec (err, character) ->
        if err then return res.serverError err
        if character
          return res.forbidden "That's not your character"
        return res.notFound "That character doesn't exist"

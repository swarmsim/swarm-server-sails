 # UserController
 #
 # @description :: Server-side logic for managing Users
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  homepage: (req, res) ->
    res.view 'homepage'
  whoami: (req, res) ->
    if not req.user?.id?
      return res.status(404).json {}
    sails.log.debug req.user
    User.findOne(req.user.id).populate('characters', sort: 'updatedAt DESC').exec (err, user) ->
      if err
        sails.log.error 'whoami failed', err
        return res.status(500).json error:true, message: "Database error"
      if not user
        return res.status(404).json {}
      return res.json user

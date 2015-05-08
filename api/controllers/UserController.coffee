 # UserController
 #
 # @description :: Server-side logic for managing Users
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  homepage: (req, res) ->
    res.view 'homepage'
  whoami: (req, res) ->
    if not req.user?.id?
      return res.notFound()
    sails.log.debug req.user
    User.findOne(req.user.id).populate('characters', deleted: false, sort: 'updatedAt DESC').exec (err, user) ->
      if err then return res.serverError err
      if not user
        return res.notFound()
      return res.ok user
  findOne: (req, res) ->
    User.findOne(req.params.id).populate('characters', deleted: false, sort: 'updatedAt DESC').exec (err, user) ->
      if err then return res.serverError err
      if not user
        return res.notFound()
      return res.ok user

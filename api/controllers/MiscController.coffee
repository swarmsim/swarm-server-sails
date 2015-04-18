 # MiscController
 #
 # @description :: Server-side logic for managing miscs
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  about: ->
    res.json
      version: require('./package.json').version
      uptimeSeconds: process.uptime()

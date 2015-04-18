 # MiscController
 #
 # @description :: Server-side logic for managing miscs
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  about: (req, res) ->
    now = new Date()
    uptime = process.uptime()
    version = require('../../package.json').version
    res.json
      version: version
      uptimeSeconds: uptime
      now: now
      #startDate: new Date now.getTime() - uptime * 1000

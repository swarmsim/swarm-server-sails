 # MiscController
 #
 # @description :: Server-side logic for managing miscs
 # @help        :: See http://links.sailsjs.org/docs/controllers

moment = require 'moment'
require 'moment-duration-format'

module.exports =
  healthy: (req, res) ->
    res.json ok: '大丈夫。'
  about: (req, res) ->
    now = new Date()
    uptime = process.uptime()
    version = require('../../package.json').version
    res.json
      version: version
      uptimeSeconds: uptime
      uptime: moment.duration(uptime, 'seconds').format()
      now: now
      approxStartDate: new Date now.getTime() - uptime * 1000

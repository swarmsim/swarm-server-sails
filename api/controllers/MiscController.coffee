 # MiscController
 #
 # @description :: Server-side logic for managing miscs
 # @help        :: See http://links.sailsjs.org/docs/controllers

moment = require 'moment'
require 'moment-duration-format'
os = require 'os'

ssl_is_used = null

module.exports =
  healthy: (req, res) ->
    # confirmed we're using a non-ssl db connection - oh no!
    # A non-successful status here will automatically remove this host from the load balancer, so it won't serve real users.
    if ssl_is_used? and !ssl_is_used
      res.status(500).json ok: false, error: 'db connection is not using ssl'
    res.json ok: '大丈夫。'

  about: (req, res) ->
    now = new Date()
    uptime = process.uptime()
    version = require('../../package.json').version
    next = =>
      res.json
        version: version
        uptimeSeconds: uptime
        uptime: moment.duration(uptime, 'seconds').format()
        now: now
        approxStartDate: new Date now.getTime() - uptime * 1000
        hostname: os.hostname()
        isDBUsingSSL: ssl_is_used
    if ssl_is_used? or req.query.skip_db_ssl_check?
      return next()
    else
      # Any model works here, nothing special about user.
      # http://stackoverflow.com/questions/18347634/is-there-a-way-for-sails-js-to-select-fields-in-sql-queries
      User.query 'select ssl_is_used();', (err, results) ->
        if err
          sails.log.error 'error selecting ssl_is_used() from db', err
          return res.status(500).json error: 'database error'
        ssl_is_used = results.rows?[0]?.ssl_is_used ? null
        sails.log.debug 'db ssl_is_used()', ssl_is_used#, results
        return next()


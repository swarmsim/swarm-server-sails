# Guest user auth strategy. Anonymous users get an entry in the users table too. Cribbed a lot from these:
# https://github.com/yuri-karadzhov/passport-hash/blob/master/lib/passport-hash/strategy.js
# https://github.com/developmentseed/passport-dummy/blob/master/lib/passport-dummy/strategy.js
passport = require 'passport'

module.exports = class Strategy extends passport.Strategy
  constructor: (@options, @protocol) ->
    if not @protocol?
      throw new Error 'protocol required'

    @name = 'guestuser'
    super()

  authenticate: (req) ->
    @protocol req, (err, user, info) =>
      if err
        return @error err
      if !user
        return @fail info
      return @success user, info

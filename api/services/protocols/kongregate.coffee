# Kongregate Authentication Protocol
#
# based on ./local.js

module.exports = (req, creds, profile, done) ->
  query =
    identifier: creds.user_id
    protocol: 'kongregate'
    # Don't store game_auth_token! It can change.
    #tokens:
    #  game_auth_token: creds.game_auth_token

  passport.connect req, query, profile, done

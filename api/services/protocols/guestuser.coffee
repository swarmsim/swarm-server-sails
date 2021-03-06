# Guest Authentication Protocol. Anonymous users get an entry in the 'users' table too.

createUser = (done) ->
  User.create username: null, email: null
  .exec (err, user) ->
    if err or not user
      return done err, user
    # Create a default character too. Client will populate its state.
    Character.create user:user, state: {}, source: 'guestFirst'
    .exec (err, character) ->
      if err or not character
        return done err, character
      done err, user

module.exports = (req, done) ->
  # maybe they're already authenticated?
  if req.user?.id?
    User.findOne id:req.user.id
    .populate 'passports'
    .exec (err, user) ->
      # valid guest users have no passports. no reason to use guest login if you have a passport.
      if user.passports?.length != 0
        return done "user id #{user.id} has non-guest auth available"
      if !err and user
        # found a valid user, use it. (not sure if common)
        return done err, user
      # invalid session user, create a new one (should be uncommon)
      return createUser done
  else
    # nope, not authenticated. new user. (common case)
    return createUser done

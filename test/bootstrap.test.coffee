Sails = new require('sails').Sails()
sails = null

# no need to `require assert` in every test!
global.assert = require 'assert'
global.sinon = require 'sinon'
global.request = require 'supertest'
global.requestApp = ->
  # http://jaketrent.com/post/authenticated-supertest-tests/
  request.agent sails.hooks.http.app

# Usage: see /test/controllers/Auth.test.coffee. tl;dr: 
# describe blah, ->
#   login = withLogin()
#   it 'does stuff', ->
#     assert login.user.id
#     login.agent.get ...
global.register = (done=->) ->
  rand = Math.floor Math.random() * 100000
  ret = agent:requestApp()
  ret.agent.post '/auth/local/register'
  .send username: "test#{rand}", password: 'testtest', email: "test#{rand}@example.com"
  .expect 200
  .end (err, res) ->
    if err then return done err
    ret.user = res.body.user
    assert ret.user.id
    done()
  return ret
global.withLogin = (fnBefore=before, fnAfter=after) ->
  ret = null
  fnBefore (done) ->
    ret = register done
  fnAfter (done) ->
    User.destroy(id:ret.user.id).exec done
  return ret
global.withLoginEach = ->
  withLogin beforeEach, afterEach

before (done) ->
  @timeout 10000
  Sails.lift
    # configuration for testing purposes
    models:
      connection: 'memory'
      migrate: 'drop'
    (err, server) ->
      sails = server
      if err
        return done err
      # here you can load fixtures, etc.
      done err, sails

after (done) ->
  # here you can clear fixtures, etc.
  sails.lower done

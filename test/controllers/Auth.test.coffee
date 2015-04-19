describe 'WithLoginHelper', ->
  login = withLogin()

  it 'logs in easy', (done) ->
    assert login.user.id
    login.agent.get '/whoami'
    .expect 200
    .end (err, res) ->
      if err then return done err
      assert.equal login.user.id, res.body.id
      done()

describe 'AuthController', ->
  it 'registers', (done) ->
    agent = requestApp()
    agent.get '/whoami'
    .expect 404
    .expect {}
    .end (err, res) ->
      if err then return done err
      User.find().exec (err, users) ->
        if err then return done err
        assert.equal 0, users.length

        agent.post '/auth/local/register'
        .send username: 'test', password: 'testtest', email: 'test@example.com'
        .expect 200
        .end (err, res) ->
          if err then return done err
          assert res.body.success
          assert res.body.user.id
          User.find().exec (err, users2) ->
            if err then return done err
            assert.equal users.length + 1, users2.length

            agent.get '/whoami'
            .expect 200
            .end (err, res) ->
              if err then return done err
              assert res.body.id
              assert.equal 'test', res.body.username
              assert.equal 'test@example.com', res.body.email
              User.destroy({}).exec (err, users) ->
                done()

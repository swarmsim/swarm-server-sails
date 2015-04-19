Strategy = require '../../../lib/passport-guestuser/strategy'
validator = require('express-validator')()

describe 'guestuser passport', ->
  it 'inits', =>
    assert.equal 'guestuser', new Strategy({}, ->).name
    assert.throws -> new Strategy {}
    assert.doesNotThrow -> new Strategy {}, ->

  it 'creates a new user for an empty request', (done) =>
    @user = {id:1}
    @protocol = sinon.spy (req, next) =>
      next null, @user
    @strategy = new Strategy {}, @protocol
    @strategy.fail = @strategy.error = sinon.stub().throws()
    @strategy.success = (user, info) =>
      assert.equal @user, user
      assert @protocol.calledOnce
      done()
    @strategy.authenticate {}

  it 'creates a new user for an invalid request user', (done) =>
    @user = {id:1}
    @protocol = sinon.spy (req, next) =>
      next null, {id:2}
    @strategy = new Strategy {}, @protocol
    @strategy.fail = @strategy.error = sinon.stub().throws()
    @strategy.success = (user, info) =>
      assert.notEqual @user, user
      assert @protocol.calledOnce
      done()
    @strategy.authenticate {user:{id:999}}

  it 'breaks for non-guests', (done) =>
    @protocol = sinon.spy (req, next) =>
      next 'fail'
    @strategy = new Strategy {}, @protocol
    @strategy.fail = @strategy.success = sinon.stub().throws()
    @strategy.error = (err) =>
      assert @protocol.calledOnce
      assert.equal 'fail', err
      done()
    @strategy.authenticate {user:{id:999}}

  # TODO these aren't too useful without a database... write integration tests
  it 'uses an existing user when valid', (done) =>
    @user = {id:1}
    @protocol = sinon.spy (req, next) =>
      next null, req.user
    @strategy = new Strategy {}, @protocol
    @strategy.fail = @strategy.error = sinon.stub().throws()
    @strategy.success = (user, info) =>
      assert.equal @user, user
      assert @protocol.calledOnce
      done()
    @strategy.authenticate {user:@user}

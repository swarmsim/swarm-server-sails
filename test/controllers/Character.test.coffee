describe 'CharacterController', ->
  before (done) =>
    @login = register =>
      @login2 = register =>
        Character.create user:@login.user.id, name: 'grez', league: 'open', state: {}
        .exec (err, character) =>
          if err then return done err
          @login.character = character
          done()
    
  it "can't list anonymously (for now)", (done) =>
    requestApp().get "/character"
    .expect 403, done
  it "can't list authed (for now)", (done) =>
    @login.agent.get "/character"
    .expect 403, done

  it "can get anonymously", (done) =>
    @login.agent.get "/character/#{@login.character.id}"
    .expect 200, done
  it "can get others", (done) =>
    @login2.agent.get "/character/#{@login.character.id}"
    .expect 200, done

  it "can't create anonymously", (done) =>
    requestApp().post "/character"
    .send user:@login.user.id, name: 'grez', state: {}
    .expect 403, done
  it "can't create others", (done) =>
    assert.notEqual @login2.user.id, @login.user.id
    @login2.agent.post "/character"
    .send user:@login.user.id, name: 'grez', state: {}
    .expect 403, done
  it "can't create ownerless", (done) =>
    @login.agent.post "/character"
    .send name: 'grez', state: {}
    .expect 400, done
  it "can create self", (done) =>
    @login.agent.post "/character"
    .send user:@login.user.id, name: 'grez', state: {}
    .expect 201, done

  it "can't update anonymously", (done) =>
    requestApp().post "/character/#{@login.character.id}"
    .send name: 'sdinaryt'
    .expect 403, done
  it "can't update others", (done) =>
    assert.notEqual @login2.user.id, @login.user.id
    @login2.agent.post "/character/#{@login.character.id}"
    .send name: 'sdinaryt'
    .expect 403, done
  it "can't create explicit ids", (done) =>
    @login.agent.post "/character/9999999"
    .send name: 'sdinaryt'
    .expect 403, done
  it "can't create explicit ids (2)", (done) =>
    @login.agent.post "/character"
    .send id: 9999999, name: 'sdinaryt'
    .expect 400, done
  it "can update self", (done) =>
    @login.agent.post "/character/#{@login.character.id}"
    .send name: 'sdinaryt'
    .expect 200, done
  it "can't update self league", (done) =>
    @login.agent.post "/character/#{@login.character.id}"
    .send league: 'temp1'
    .expect 400, done
  it "can't update self user", (done) =>
    @login.agent.post "/character/#{@login.character.id}"
    .send user: 999
    .expect 400, done

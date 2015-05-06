describe 'CommandController', ->
  before (done) =>
    @login = register =>
      @login2 = register =>
        Character.create user:@login.user.id, name: 'grez', league: 'open', state: {character:true}
        .exec (err, character) =>
          if err then return done err
          @login.character = character
          Command.create character:@login.character.id, body: {}, state: {command:true}
          .exec (err, command) =>
            if err then return done err
            @login.command = command
            done()

  it "can't list anonymously (for now)", (done) =>
    requestApp().get "/command"
    .expect 403, done
  it "can't list authed (for now)", (done) =>
    @login.agent.get "/command"
    .expect 403, done
  it "can't get anonymously", (done) =>
    requestApp().get "/command/#{@login.command.id}"
    .expect 403, done
  it "can't get authed", (done) =>
    @login.agent.get "/command/#{@login.command.id}"
    .expect 403, done
  it "can't update anonymously", (done) =>
    requestApp().post "/command/#{@login.command.id}"
    .send body:{foo:'bar'}
    .expect 403, done
  it "can't update authed", (done) =>
    @login.agent.post "/command/#{@login.command.id}"
    .send body:{foo:'bar'}
    .expect 403, done
  it "can't create anonymously", (done) =>
    requestApp().post "/command/"
    .send character:@login.character.id, body:{foo:'bar'}, state: {baz:'quux'}
    .expect 403, done
  it "can't create other", (done) =>
    @login2.agent.post "/command/"
    .send character:@login.character.id, body:{foo:'bar'}, state: {baz:'quux'}
    .expect 403, done

  it "can create self", (done) =>
    @login.agent.post "/command/"
    .send character:@login.character.id, body:{foo:'bar'}, state: {baz:'quux'}
    .expect 201, done

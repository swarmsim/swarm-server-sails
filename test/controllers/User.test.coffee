describe 'UserController', ->
  before (done) =>
    @login = register =>
      @login2 = register done
    
  it "can edit self", (done) =>
    @login.agent.post "/user/#{@login.user.id}"
    .send id: @login.user.id, username: 'dsfargeg'
    .expect 200
    .end done
  it "can't edit role (isadmin)", (done) =>
    @login.agent.post "/user/#{@login.user.id}"
    .send id: @login.user.id, role: 'admin'
    .expect 403
    .end done
  it "can't edit others", (done) =>
    @login.agent.post "/user/#{@login2.user.id}"
    .send id: @login.user.id, username: 'dsfargeg2'
    .expect 403
    .end done
  it "can list self characters", (done) =>
    requestApp().get "/user/#{@login.user.id}/characters"
    .expect 200, done
  it "can list others characters", (done) =>
    requestApp().get "/user/#{@login2.user.id}/characters"
    .expect 200, done
  it "can list self passports", (done) =>
    requestApp().get "/user/#{@login.user.id}/passports"
    .expect 403, done
  it "can't list others passports", (done) =>
    requestApp().get "/user/#{@login2.user.id}/passports"
    .expect 403, done

  it "can view anonymously", (done) =>
    requestApp().get "/user/#{@login.user.id}"
    .expect 200, done
  it "can list characters anonymously", (done) =>
    requestApp().get "/user/#{@login.user.id}/characters"
    .expect 200, done
  it "can't list passports anonymously", (done) =>
    requestApp().get "/user/#{@login.user.id}/passports"
    .expect 403, done
  it "can't create anonymously", (done) =>
    requestApp().post "/user/#{@login.user.id}"
    .send username: 'fgsfds', email: 'fgsfds@example.com'
    .expect 403, done
  it "can't edit anonymously", (done) =>
    requestApp().post '/user'
    .send id: @login.user.id, username: 'dsfargeg'
    .expect 403, done
  it "can't list anonymously (for now)", (done) =>
    requestApp().get '/user'
    .expect 403, done

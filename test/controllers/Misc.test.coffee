describe 'MiscController', ->
  it "is /healthy (baby's first controller test)", (done) ->
    requestApp().get '/healthy'
    .expect 'content-type', /json/
    .expect 200
    .end (err, res) ->
      assert res.body.ok
      done err

  it 'shows /about info', (done) ->
    requestApp().get '/about?skip_db_ssl_check'
    .expect 'content-type', /json/
    .expect 200
    .end (err, res) ->
      assert res.body.version
      assert res.body.uptime
      assert res.body.uptimeSeconds
      assert res.body.hostname
      done err

  it 'shows /about info at / too', (done) ->
    requestApp().get '/?skip_db_ssl_check'
    .end (err, res) ->
      requestApp().get '/about?skip_db_ssl_check'
      .end (err, aboutRes) ->
        assert res.body.version
        assert.equal res.body.version, aboutRes.body.version
        assert.deepEqual _.keys(res.body), _.keys(aboutRes.body)
        done err

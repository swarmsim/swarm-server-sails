describe 'user', ->
  before (done) ->
    User.destroy().exec done
  it 'cruds', (done) ->
    User.find().exec (err, users) ->
      assert.equal 0, users.length
      done()

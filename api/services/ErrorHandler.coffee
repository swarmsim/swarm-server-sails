exports.handleError = (res, stepName, next) ->
  (err, result) ->
    # log errors, return 500, and rollback. don't call next.
    # don't show the database error text in the response.
    if err
      # errorId correlates log messages to the user-visible error.
      errorId = shortid.generate()
      sails.log.error '500 error', errorId: errorId, stepName: stepName, message: err
      return res.status(500).json error:"database error: #{stepName}. error id '#{errorId}'"
    else
      # no error.
      return next result

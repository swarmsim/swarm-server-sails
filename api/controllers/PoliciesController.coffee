 # PoliciesController
 #
 # @description :: Server-side logic for managing policies
 # @help        :: See http://links.sailsjs.org/docs/controllers

aws = require 'aws-sdk'
https = require 'https'
crypto = require 'crypto'
querystring = require 'querystring'
moment = require 'moment'

SECRETS =
  KONGREGATE_API_KEY: process.env.KONGREGATE_API_KEY
  AWS_REGION: process.env.AWS_REGION
  AWS_ACCESS_KEY_ID: process.env.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY: process.env.AWS_SECRET_ACCESS_KEY
  BUCKET: process.env.BUCKET

textResponse = (res, callback) ->
  body = ''
  res.on 'data', (chunk) ->
    body += chunk
  res.on 'end', ->
    callback body

jsonResponse = (res, callback) ->
  textResponse res, (body, res) ->
    callback JSON.parse body

# Asynchronously migrate a legacy key, if necessary.
# No need to send the user a response.
migrateLegacyKey = (s3, key, legacykey) ->
  # http://stackoverflow.com/questions/26726862/how-to-determine-if-object-exists-aws-s3-node-js-sdk
  sails.log.debug 'migratelegacykey: checking modern save existence', key, legacykey
  s3.headObject
    Bucket: SECRETS.BUCKET
    Key: key
    (err, response) ->
      if err?.code == 'NotFound'
        sails.log.debug 'migratelegacykey: confirmed modern save does not exist. attempting to copy from legacy (which may or may not exist)', key, legacykey
        s3.copyObject
          Bucket: SECRETS.BUCKET
          CopySource: "#{SECRETS.BUCKET}/#{legacykey}"
          Key: key
          (err, response) ->
            if err?.code == 'NotFound' or err?.code == 'NoSuchKey'
              sails.log.debug 'migratelegacykey: confirmed legacy key does not exist (and modern save does not exist). done.', key, legacykey
            else if !err
              sails.log.debug 'migratelegacykey: successfully copied from legacy to modern. attempting to delete legacy.', key, legacykey
              s3.deleteObject
                Bucket: SECRETS.BUCKET
                Key: legacykey
                (err, response) ->
                  if err
                    sails.log.warn 'migratelegacykey: failed to delete legacy save (freshly migrated). giving up.', err, key, legacykey
                  else
                    sails.log.debug 'migratelegacykey: deleted legacy save (freshly migrated). done.', key, legacykey
            else
              sails.log.warn 'migratelegacykey: failed to copy legacy save to modern save. giving up.', err, key, legacykey
      else if !err
        # modern save exists (the common case). we could try to delete the legacy save now.
        # but... I'm paranoid. Let's wait a bit first.
        sails.log.debug 'migratelegacykey: confirmed modern save exists. attempting to delete legacy (actually, no deletes yet).', key, legacykey
        # Don't delete just yet. This'll make deleteSave misbehave, but no one ever uses it anyway.
        #s3.deleteObject
        #  Bucket: SECRETS.BUCKET
        #  Key: legacykey
        #  (err, response) ->
        #    if err?.code == 'NotFound'
        #      # Looks like this never happens. Keep it around to distinguish from other errors, just in case.
        #      sails.log.debug 'migratelegacykey: confirmed legacy key does not exist (preexisting modern save). done.', key, legacykey
        #    else if !err
        #      sails.log.debug 'migratelegacykey: deleted legacy save (preexisting modern save). done.', key, legacykey
        #    else
        #      sails.log.warn 'migratelegacykey: failed to delete legacy save (preexisting modern save). giving up.', err, key, legacykey
      else
        sails.log.debug 'migratelegacykey: error checking for modern save existence. giving up.', err, key, legacykey

module.exports =
  create: (req, res) ->
    req.checkBody('policy.user_id').notEmpty().isInt()
    req.checkBody('policy.game_auth_token').notEmpty()
    if (errors=req.validationErrors())
      return res.status(400).json errors:errors
    policy = req.body.policy
    kong_args = {user_id:policy.user_id, game_auth_token:policy.game_auth_token, api_key:SECRETS.KONGREGATE_API_KEY}
    kong_url = "https://api.kongregate.com/api/authenticate.json?#{querystring.stringify kong_args}"
    #sails.log 'requesting', kong_url
    https.get kong_url, (kongres) ->
      jsonResponse kongres, (kongjson) ->
        if kongjson.success
          # valid user!
          #res.send "howdy from policies.create #{res.statusCode} #{JSON.stringify kongjson}"
          # http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-examples.html
          s3 = new aws.S3()
          # TODO hash auth_token? this will go away soon anyway
          #legacykey = "saves/#{policy.game_auth_token}_#{policy.user_id}.json"
          # Nope, don't store auth token at all! See https://github.com/swarmsim/swarm/issues/624 - auth tokens can change.
          # saves2/ to distinguish legacy saves from modern saves by prefix, for easy listing.
          key = "saves2/#{policy.user_id}.json"
          migrateLegacyKey s3, key, "saves/#{policy.game_auth_token}_#{policy.user_id}.json"

          expires_in = 60 * 60 * 24 * 1
          expires_date = moment.utc().add expires_in, 'seconds'
          doc =
            expiration: expires_date.toISOString()
            conditions: [
              {bucket: SECRETS.BUCKET}
              {key: key}
              {acl: 'private'}
              {'Content-Type': 'application/json'}
              ['content-length-range', 0, 16384]
            ]
          # signed post policy. http://stackoverflow.com/questions/18476217
          doc64 = Buffer(JSON.stringify(doc), 'utf-8').toString 'base64'
          signature = crypto.createHmac('sha1', SECRETS.AWS_SECRET_ACCESS_KEY).update(new Buffer(doc64, 'utf-8')).digest 'base64'
          # construct response
          ret = {}
          # 'Expires' is in seconds
          ret.get = s3.getSignedUrl 'getObject', Bucket: SECRETS.BUCKET, Key: key, Expires: expires_in
          ret.delete = s3.getSignedUrl 'deleteObject', Bucket: SECRETS.BUCKET, Key: key, Expires: expires_in
          ret.post =
            url: "https://#{SECRETS.BUCKET}.s3.amazonaws.com"
            params:
              key: key
              AWSAccessKeyId: SECRETS.AWS_ACCESS_KEY_ID
              acl: 'private'
              policy: doc64
              signature: signature
              "Content-type": "application/json"
          ret.expiresIn = expires_in
          ret.serverDate =
            #refreshed: moment.utc().unix()
            refreshed: moment.utc().valueOf()
            expires: expires_date.valueOf()
          res.json ret
        else # !kongjson.success; invalid user
          res.status if (400 <= kongjson.error < 500) then 400 else 500
          res.json kongjson
          return
    .on 'error', (e) ->
      sails.log.error 'kongregate-auth error', e

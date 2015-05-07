 # Command.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  schema: true
  # immutable
  autoUpdatedAt: false

  attributes:
    character:
      model: 'character'
      required: true
    body:
      type: 'json'
      required: true
    state:
      type: 'json'
      required: true

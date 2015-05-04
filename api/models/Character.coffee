 # Character.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  schema: true

  attributes:
    user:
      model: 'user'
      required: true
    name:
      type: 'string'
      size: 20
      required: true
      defaultsTo: 'Unnamed Swarm'
    state:
      type: 'json'
      required: true
    deleted:
      type: 'boolean'
      required: true
      defaultsTo: false
    source:
      type: 'string'
      enum: ['unspecified', 'connectLegacy', 'guestFirst', 'newCharForm']
      size: 20
      defaultsTo: 'unspecified'
      required: true
    # TODO
    #commands:
    #  collection: 'command'
    #  via: 'character'

@boot = require './boot'

@boot (app) ->
  require('./routes').connect app
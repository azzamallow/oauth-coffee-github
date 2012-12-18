module.exports = (initializer) ->
  express = require 'express',
  partials = require 'express-partials'
  app = express();

  app.configure ->
    app.engine 'haml', require('haml-coffee').__express
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'haml'
    app.use partials()
    app.use express.logger()
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.session({ secret: 'keyboard cat' })
    app.use app.router

  initializer app

  app.listen 3000
  console.log 'Listening on port 3000'
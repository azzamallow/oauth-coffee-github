express = require 'express',
partials = require 'express-partials',
passport = require('./lib/github-passport.coffee').passport

@app = express();
@app.configure =>
  @app.engine 'haml', require('haml-coffee').__express
  @app.set 'views', __dirname + '/views'
  @app.set 'view engine', 'haml'
  @app.use partials()
  @app.use express.logger()
  @app.use express.cookieParser()
  @app.use express.bodyParser()
  @app.use express.methodOverride()
  @app.use express.session({ secret: 'keyboard cat' })
  @app.use passport.initialize()
  @app.use passport.session()
  @app.use @app.router
  @app.use express.static(__dirname + '/public')

require('./routes').connect @app, passport

@app.listen 3000
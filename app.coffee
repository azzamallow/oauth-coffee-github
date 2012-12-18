express = require 'express',
partials = require 'express-partials'

@app = express();
@ouath = require './lib/github-oauth.coffee'

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
  @app.use @ouath.initialize()
  @app.use @ouath.session()
  @app.use @app.router
  @app.use express.static(__dirname + '/public')

require('./routes').connect @app, @ouath

@app.listen 3000
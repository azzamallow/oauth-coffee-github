express = require 'express',
partials = require 'express-partials'

@app = express();

GitHubApi = require 'github'

github = new GitHubApi { version: '3.0.0' }

OAuth2 = require('oauth').OAuth2

oauth2 = new OAuth2 process.env.GITHUB_CLIENT_ID, 
                    process.env.GITHUB_CLIENT_SECRET,
                    '', 
                    'https://github.com/login/oauth/authorize', 
                    'https://github.com/login/oauth/access_token'

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
  @app.use @app.router

@app.get '/auth/github/callback', (req, res) ->
  oauth2.getOAuthAccessToken req.query.code, {}, (error, access_token, refresh_token, results) ->
    if results.error?
      res.send results.error
    else
      github.authenticate {
        type: 'oauth',
        token: access_token
      }
      res.redirect '/repos'

@app.get '/auth/github', (req, res) ->
  res.redirect oauth2.getAuthorizeUrl()

@app.get '/repos', (req, res) ->
  github.repos.getAll {}, (error, result) ->
    res.send result.map (repo) -> repo.name

@app.listen 3000
console.log 'loaded'
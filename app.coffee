express = require 'express',
passport = require 'passport',
util = require 'util',
GitHubStrategy = require('passport-github').Strategy

GITHUB_CLIENT_ID = process.env.GITHUB_CLIENT_ID
GITHUB_CLIENT_SECRET = process.env.GITHUB_CLIENT_SECRET

ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

passport.use new GitHubStrategy {
    clientID: GITHUB_CLIENT_ID,
    clientSecret: GITHUB_CLIENT_SECRET,
    callbackURL: "http://localhost:3000/auth/github/callback"
  },
  (accessToken, refreshToken, profile, done) ->
    process.nextTick ->
      done null, profile

@app = express();
@app.configure =>
  @app.set 'views', __dirname + '/views'
  @app.set 'view engine', 'ejs'
  @app.use express.logger()
  @app.use express.cookieParser()
  @app.use express.bodyParser()
  @app.use express.methodOverride()
  @app.use express.session({ secret: 'keyboard cat' })
  @app.use passport.initialize()
  @app.use passport.session()
  @app.use @app.router
  @app.use express.static(__dirname + '/public')


@app.get '/', (req, res) ->
  res.render 'layout', { user: req.user, body: 'example stuff' }

@app.get '/account', ensureAuthenticated, (req, res) ->
  res.render 'account', { user: req.user }

@app.get '/login', (req, res) ->
  res.render 'login', { user: req.user }

@app.get '/auth/github',
  passport.authenticate('github'),
  (req, res) ->

@app.get '/auth/github/callback', 
  passport.authenticate('github', { failureRedirect: '/login' }),
  (req, res) ->
    res.redirect '/'

@app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

@app.listen 3000
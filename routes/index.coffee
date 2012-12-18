gitHub = require '../lib/github.coffee'

exports.connect = (app) ->
  app.get '/',                     index
  app.get '/login',                login
  app.get '/logout',               gitHub.deauthorize, redirect
  app.get '/account',              ensureAuthenticated, account
  app.get '/auth/github',          gitHub.authorize
  app.get '/auth/github/callback', gitHub.access(failureRedirect: '/login'), redirect   

index = (req, res) ->
  if req.session.username?
    res.render 'index', username: req.session.username
  else
    res.redirect '/login'

login = (req, res) ->
  res.render 'login'

ensureAuthenticated = (req, res, next) ->
  return next() if req.session.username?
  res.redirect '/login'

account = (req, res) ->
  gitHub.repositories (repositories) ->
    res.render 'account', username: req.session.username, repositories: repositories

redirect = (req, res) ->
  res.redirect '/'
gitHub = require '../lib/github.coffee'

handle = {

  index: (req, res) ->
    if req.session.username?
      res.render 'index', { username: req.session.username } 
    else
      res.redirect '/login'

  login: (req, res) ->
    res.render 'login'

  ensureAuthenticated: (req, res, next) ->
    return next() if req.session.username?
    res.redirect '/login'

  account: (req, res) ->
    gitHub.repositories (repositories) ->
      res.render 'account', { username: req.session.username, repositories: repositories }

  redirect: (req, res) ->
    res.redirect '/'
}

exports.connect = (app) ->
  app.get '/',                     handle.index
  app.get '/login',                handle.login
  app.get '/logout',               gitHub.deauthorise
  app.get '/account',              handle.ensureAuthenticated, handle.account
  app.get '/auth/github',          gitHub.authorise
  app.get '/auth/github/callback', gitHub.access({ failureRedirect: '/login' }), handle.redirect
    
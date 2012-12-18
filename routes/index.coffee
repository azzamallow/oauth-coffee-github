handle = {

  index: (req, res) ->
    if req.user?
      res.render 'index', { user: req.user } 
    else
      res.redirect '/login'

  login: (req, res) ->
    res.render 'login'

  logout: (req, res) ->
    req.logout()
    res.redirect '/'

  ensureAuthenticated: (req, res, next) ->
    return next() if req.isAuthenticated()
    res.redirect '/login'

  account: (req, res) ->
    res.render 'account', { user: req.user }

  redirect: (req, res) ->
    res.redirect '/'

}

exports.connect = (app, oauth) ->
  app.get '/',                     handle.index
  app.get '/login',                handle.login
  app.get '/logout',               handle.logout
  app.get '/account',              handle.ensureAuthenticated, handle.account
  app.get '/auth/github',          oauth.authenticate('github')
  app.get '/auth/github/callback', oauth.authenticate('github', { failureRedirect: '/login' }), handle.redirect
    
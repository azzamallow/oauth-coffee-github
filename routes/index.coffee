ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'

exports.connect = (app, passport) ->
  app.get '/', (req, res) ->
    if req.user?
      res.render 'index', { user: req.user } 
    else
      res.redirect '/login'

  app.get '/account', ensureAuthenticated, (req, res) ->
    res.render 'account', { user: req.user }

  app.get '/auth/github', passport.authenticate('github')

  app.get '/auth/github/callback', 
    passport.authenticate('github', { failureRedirect: '/login' }),
    (req, res) ->
      res.redirect '/'

  app.get '/login', (req, res) ->
    res.render 'login'

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'
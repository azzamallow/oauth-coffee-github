GitHub = require 'github'
github = new GitHub version: '3.0.0'

OAuth2 = require('oauth').OAuth2
oauth2 = new OAuth2 process.env.GITHUB_CLIENT_ID, 
                    process.env.GITHUB_CLIENT_SECRET,
                    'https://github.com/', 
                    'login/oauth/authorize', 
                    'login/oauth/access_token'

exports.authorize = (req, res) ->
  res.redirect oauth2.getAuthorizeUrl()

exports.deauthorize = (req, res, next) ->
  req.session.username = null
  next()

exports.access = (options) ->
  (req, res, next) ->
    oauth2.getOAuthAccessToken req.query.code, {}, (error, accessToken, refreshToken, results) ->
      return res.redirect options.failureRedirect if error? or results.error?
    
      github.authenticate type: 'oauth', token: accessToken

      github.user.get {}, (error, user) ->
        req.session.username = user.name
        next()

exports.repositories = (callback) ->
  github.repos.getAll {}, (error, repositories) ->
    callback repositories.map (repository) -> id: repository.id, name: repository.name
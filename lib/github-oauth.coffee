passport = require 'passport',

GitHubStrategy = require('passport-github').Strategy,

params = {
  clientID:     process.env.GITHUB_CLIENT_ID,
  clientSecret: process.env.GITHUB_CLIENT_SECRET,
  callbackURL:  "http://localhost:3000/auth/github/callback"
}

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

passport.use new GitHubStrategy params, (accessToken, refreshToken, profile, done) ->
  process.nextTick ->
    done null, profile

exports = module.exports = passport
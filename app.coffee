express = require 'express'
routes = require './routes'
MongoStore = require('connect-mongo')(express)
jqtpl = require 'jqtpl'
mongoose = require 'mongoose'

app = module.exports = express.createServer()

# Configuration
app.configure ->
  app.set 'sesssecret', '7800f691d6ed4f36b2338b0a8d452dc0'
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'html'
  app.register ".html", jqtpl.express
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.set 'database', 'mattfrmr-dev'
  app.set 'port', 3000

app.configure 'production', ->
  app.use express.errorHandler()
  app.set 'database', 'mattfrmr'
  app.set 'port', 9701

app.configure ->
  app.use express.session({ secret: app.settings.sesssecret, store: new MongoStore({db: app.settings.database}) })
  mongoose.connect 'mongodb://localhost/' + app.settings.database
  app.use app.router
  app.use express.static(__dirname + '/public')

# Routes
app.get '/', routes.index

app.listen app.settings.port, ->
  console.log "matt.frmr.me listening on port %d in %s mode", app.address().port, app.settings.env


http = require 'http'
stylus = require 'stylus'
nib = require 'nib'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
session = require 'express-session'
errorhandler = require 'errorhandler'
dojo = require 'connect-dojo'
coffee = require 'connect-coffee-script'
serve_favicon = require 'serve-favicon'
serve_index = require 'serve-index'
serve_static = require 'serve-static'
db = require './db'
# config = require '../conf/hdfs'

app = express()

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session secret: 'toto', resave: true, saveUninitialized: true

app.use coffee
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  bare: true
app.use stylus.middleware
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  compile: (str, path) ->
    stylus(str)
    .set('filename', path)
    .set('compress', config?.css?.compress)
    .use nib()
app.use serve_static "#{__dirname}/../public"

app.get '/', (req, res, next) ->
  res.render 'index',title: 'Express'

app.post '/user/login', (req, res, next) ->
  #TODO: Get la bdd
  res.json
    type:  req.body.username
    #get de la bdd c'est ce qui est envoyé à la vue (data dans le post)

test = db "../db"
app.post '/user/signup', (req, res, next) ->
  test.users.set req.body.username,
    lastname: "Mika"
    firstname: "Benaim"
    email: "david@adaltas.com"
  , (err) ->
    return next err if err
  res.json
    type: 'Signup'

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()


module.exports = app

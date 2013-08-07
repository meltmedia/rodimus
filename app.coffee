# Module dependencies
express = require('express')
http = require('http')
fs = require('fs')
app = express()

# File dependencies
Transformer = require('./transformer')
Uploader = require('./uploader')

# all environments
app.configure ->
  app.set 'port', process.env.PORT or 3000
  app.set 'views', __dirname + '/views'
  app.set('view engine', 'coffee')
  app.engine 'coffee', require('coffeecup').__express

  #app.enable('view cache')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use '/public', express.static('public')

# Routes
app.get '/', (req, res) ->
  res.render 'home',
    title: 'Rodimus'

# done
app.get '/d/:uniq_dir', (req, res) ->
  output = '/public/docs/' + req.params.uniq_dir + '/file.zip'

  res.render 'done',
    title: 'Rodimus has finished transforming your document.'
    loc: output

# transforming (where the magic happens)
app.get '/t/:uniq_dir', (req, res) ->
  uniq_dir = req.params.uniq_dir
  rodimus = new Transformer uniq_dir, ->
    res.redirect '/d/' + uniq_dir
  
#rodimus.render res

# upload handler
app.post '/file-upload', (req, res) ->
  uploadHandler = new Uploader req, (uniq_dir) -> 
    res.redirect '/t/' + uniq_dir

# development only
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  #######

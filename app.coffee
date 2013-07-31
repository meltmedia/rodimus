# Module dependencies
express = require('express')
http = require('http')
fs = require('fs')
app = express()

# File dependencies
Transformer = require('./transformer')

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
  app.use express.static(__dirname + '/public')

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
  rodimus = new Transformer uniq_dir

# upload handler
app.post '/file-upload', (req, res) ->
  
  # get the temporary location of the file
  tmp_path = req.files.document.path
  uniq_dir = tmp_path.split('/')[2]
  
  # set where the file should actually exist
  target_path = './public/docs/' + uniq_dir + '/file.docx'
  fs.mkdir './public/docs/' + uniq_dir
  
  # move the file to the intended location
  fs.rename tmp_path, target_path, ->
    
    # delete the temporary file
    fs.unlink tmp_path, ->
      
      # send user to 'transforming'
      res.redirect '/t/' + uniq_dir

# development only
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  #######

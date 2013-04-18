###
Module dependencies.
###
express = require('express')
http = require('http')
fs = require('fs')
app = express()
childProcess = require('child_process')
zip = require('express-zip')

# all environments
app.configure ->
  app.set 'port', process.env.PORT or 3000
  app.set 'views', __dirname + '/views'
  app.set('view engine', 'coffee')
  app.engine 'coffee', require('coffeecup').__express  

  #app.enable('view cache');
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')


# Routes
app.get '/', (req, res) ->
  res.render 'home',
    title: 'Rodimus'


app.get '/t/:uniq_dir', (req, res) ->
  doc = 'public/docs/' + req.params.uniq_dir + '/file.docx'
  new_path = 'public/docs/' + req.params.uniq_dir + '/file'
  fs.mkdir './' + new_path

  res.render 'transforming',
    title: 'Rodimus is transforming your document.' + req.params.uniq_dir,
    loc: './' + doc
    
  transform = childProcess.exec('/usr/bin/java -jar ./rodimus-0.1.0-SNAPSHOT.jar ' + doc + ' ' + new_path, (error, stdout, stderr) ->
#     if stdout
#       console.log 'stdout: ' + stdout
#     if stderr
#       console.log 'stderr: ' + stderr
    throw err  if err

    fs.unlink doc, ->
      throw err  if err
  )

  res.zip [
    path: new_path
    name: new_path + '.zip'
  ]

# upload handler
app.post '/file-upload', (req, res) ->
  
  # get the temporary location of the file
  tmp_path = req.files.document.path
  uniq_dir = tmp_path.split('/')[2]
  
  # set where the file should actually exist
  target_path = './public/docs/' + uniq_dir + '/file.docx'
  fs.mkdir './public/docs/' + uniq_dir
  
  # move the file to the intended location
  fs.rename tmp_path, target_path, (err) ->
    console.log err  if err
    
    # delete the temporary file
    fs.unlink tmp_path, ->
      throw err  if err
      
      #res.send('File uploaded to: ' + target_path + ' - ' + req.files.document.size + ' bytes');
      res.redirect '/t/' + uniq_dir

# development only
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  #######
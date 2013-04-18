###
Module dependencies.
###
express = require('express')
http = require('http')
fs = require('fs')
app = express()
childProcess = require('child_process')

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
  # paths
  doc = 'public/docs/' + req.params.uniq_dir + '/file.docx'
  new_path = 'public/docs/' + req.params.uniq_dir + '/file'
  trash_dir = 'public/docs/' + req.params.uniq_dir + '/tmp'
  fs.mkdir './' + new_path
  fs.mkdir trash_dir

  res.render 'transforming',
    title: 'Rodimus is transforming your document.' + req.params.uniq_dir,
    loc: './' + doc
  
  # execute rodimus
  transform = childProcess.exec('/usr/bin/java -jar ./rodimus-0.1.0-SNAPSHOT.jar ' + doc + ' ' + new_path, (err, stdout, stderr) ->
#     if stdout
#       console.log 'stdout: ' + stdout
#     if stderr
#       console.log 'stderr: ' + stderr
    throw err if err

    # move file.docx and delete it
    fs.rename doc, trash_dir + '/file.docx', ->
      fs.unlink trash_dir
  )

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
      
      #res.send('File uploaded to: ' + target_path + ' - ' + req.files.document.size + ' bytes');
      res.redirect '/t/' + uniq_dir

# development only
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  #######
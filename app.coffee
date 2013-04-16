
###
Module dependencies.
###
express = require('express')
http = require('http')
fs = require('fs')
app = express()
childProcess = require('child_process')

transform = childProcess.exec("blah", (error, stdout, stderr) ->
  console.log "exec error: " + error  if error isnt null
)

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


app.get '/:uniq_dir', (req, res) ->
  res.render 'transforming',
    title: 'Rodimus is transforming your document.',
    loc: './public/docs/' + req.params.uniq_dir + '/file.docx'

#   res.send 'File uploaded to: public/docs/'


#
#app.post('/file-upload', function(req, res, next) {
#  console.log(req.body);
#  console.log(req.files);
#});
#

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
      res.redirect '/' + uniq_dir




# development only
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  #######
var exec = require('child_process').exec, child;
child = exec('/usr/bin/java -jar ~/Applications/example.jar',
  function (error, stdout, stderr){
    console.log('stdout: ' + stdout);
    console.log('stderr: ' + stderr);
    if(error !== null){
      console.log('exec error: ' + error);
    }
});
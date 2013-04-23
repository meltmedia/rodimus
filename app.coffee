###
Module dependencies.
###
express = require('express')
http = require('http')
fs = require('fs')
app = express()
childProcess = require('child_process')
wrench = require('wrench')
AdmZip = require('adm-zip')

zip = new AdmZip()

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

# done
app.get '/d/:uniq_dir', (req, res) ->
  output = '/public/docs/' + req.params.uniq_dir + '/file.zip'

  res.render 'done',
    title: 'Rodimus has finished transforming your document.'
    loc: output

# transforming (where the magic happens)
app.get '/t/:uniq_dir', (req, res) ->
  # paths
  uniq_dir = req.params.uniq_dir
  doc = 'public/docs/' + uniq_dir + '/file.docx'
  new_path = 'public/docs/' + uniq_dir + '/file'
  trash_dir = 'public/docs/' + uniq_dir + '/tmp'
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

    # move file.docx to trash
    fs.rename doc, trash_dir + '/file.docx', ->

      # compress output from rodimus
      zip.addLocalFolder new_path
      zip.writeZip new_path + '.zip'

      # move rodimus to trash
      fs.mkdir trash_dir + '/rodimus'
      fs.rename new_path, trash_dir + '/rodimus', ->
        
        # take out the trash
        wrench.rmdirSyncRecursive trash_dir

        # send user to 'done'
        res.redirect '/d/' + uniq_dir
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
      
      # send user to 'transforming'
      res.redirect '/t/' + uniq_dir

# development only
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
  #######
# Module dependencies.
fs = require('fs')
childProcess = require('child_process')

# File dependencies
fileHandler = require('./file_handler')

class Transformer
  # Constructor
  constructor: (@uniq_dir) ->
    @initVars
    @render
    @process

  # Init Variables
  initVars: () ->
    @doc = 'public/docs/' + @uniq_dir + '/file.docx'
    @new_path = 'public/docs/' + @uniq_dir + '/file'
    @trash_dir = 'public/docs/' + @uniq_dir + '/tmp'
    @initPaths()

  # Init Paths
  initPaths: () ->
    fs.mkdir './' + @new_path
    fs.mkdir @trash_dir

  # Render 'processing' page
  render: () ->
    res.render 'transforming',
      title: 'Rodimus is transforming your document.' + @uniq_dir,
      loc: './' + @doc

  # Process file through Rodimus
  process: () ->
    # Build command
    command = '/usr/bin/java -jar ./rodimus-0.1.0-SNAPSHOT.jar '
    command += @doc + ' ' + @new_path

    # Execute command
    transform = childProcess.exec command, (err, stdout, stderr) ->
      throw err if err

      @rollOut

  # Save output and delete input
  rollOut: () ->
    # move file.docx to trash
    fileHandler.move @doc, @trash_dir + '/file.docx'

    # compress output from rodimus
    fileHandler.compress @new_path

    # move rodimus to trash
    fileHandler.moveDir @new_path, @trash_dir + '/rodimus'
        
    # take out the trash
    fileHandler.removeDir @trash_dir

    # send user to 'done'
    res.redirect '/d/' + @uniq_dir

# Expose
module.exports = Transformer

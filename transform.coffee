###
Module dependencies.
###
fs = require('fs')
childProcess = require('child_process')
wrench = require('wrench')
AdmZip = require('adm-zip')

zip = new AdmZip()

# Constructor
class Transformer
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

      @fileHandler

  # Save output and delete input
  fileHandler: () ->
    # move file.docx to trash
    fs.rename @doc, @trash_dir + '/file.docx', ->

      # compress output from rodimus
      zip.addLocalFolder @new_path
      zip.writeZip @new_path + '.zip'

      # move rodimus to trash
      fs.mkdir @trash_dir + '/rodimus'
      fs.rename @new_path, @trash_dir + '/rodimus', ->
        
        # take out the trash
        wrench.rmdirSyncRecursive @trash_dir

        # send user to 'done'
        res.redirect '/d/' + @uniq_dir

# Expose
module.exports = Transformer

# Module dependencies.
fs = require('fs')
wrench = require('wrench')
childProcess = require('child_process')

fileHandler =
  isDir: (path) ->
    stats = fs.lstatSync path
    stats.isDirectory()

  move: (currentPath, newPath) ->
    if @isDir currentPath
      opts = forceDelete: true
      wrench.copyDirSyncRecursive currentPath, newPath, opts
      wrench.rmdirSyncRecursive currentPath, opts
    else
      fs.rename currentPath, newPath, (err) ->
        throw err if err
  
  archive: (uniq_dir) ->
    # Build command
    execPath = __dirname + '/public/docs/' + uniq_dir
    tarPath = 'public/docs/' + uniq_dir + '/file.tar'
    command = '/usr/bin/env tar -C ' + execPath + ' -cf ' + tarPath + ' file'
    # Execute command
    childProcess.exec command, (err, stdout, stderr) ->
      throw err if err

  delete: (path) ->
    if @isDir path
      opts = forceDelete: true
      wrench.rmdirSyncRecursive path, opts
    else
      fs.unlinkSync path

# Expose
module.exports = fileHandler

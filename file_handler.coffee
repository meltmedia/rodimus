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
        console.log err if err
  
  archive: (uniq_dir, callback) ->
    tarPath = 'public/docs/' + uniq_dir + '/file.tar'
    command = '/usr/bin/env tar -C ' + __dirname + '/public/docs/' + uniq_dir + ' -cf ' + tarPath + ' file'
    childProcess.exec command, (err, stdout, stderr) ->
      throw err if err
      callback()

  delete: (path) ->
    if @isDir path
      opts = forceDelete: true
      wrench.rmdirSyncRecursive path, opts
    else
      fs.unlinkSync path

# Expose
module.exports = fileHandler

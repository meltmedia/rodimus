# Module dependencies.
fs = require('fs')
wrench = require('wrench')
AdmZip = require('adm-zip')

fileHandler =
  isDir: (path) ->
    stats = fs.statSync path
    stats.isDirectory()

  move: (currentPath, newPath) ->
    if @isDir currentPath
      fs.mkdir newPath
    fs.renameSync currentPath, newPath

  compress: (dir) ->
    zip = new AdmZip()
    zip.addLocalFolder dir
    zip.writeZip dir + '.zip'

  delete: (path) ->
    if @isDir path
      opts =
        forceDelete: true
      wrench.rmdirSyncRecursive path, opts
    else
      fs.unlinkSync path

# Expose
module.exports = fileHandler

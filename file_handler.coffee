# Module dependencies.
fs = require('fs')
wrench = require('wrench')
Zip = require('adm-zip')

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

  compress: (dir) ->
    zip = new Zip()
    zipPath = dir + '.zip'

    zip.addLocalFolder dir, zipPath
    zip.writeZip zipPath

  delete: (path) ->
    if @isDir path
      opts = forceDelete: true
      wrench.rmdirSyncRecursive path, opts
    else
      fs.unlinkSync path

# Expose
module.exports = fileHandler

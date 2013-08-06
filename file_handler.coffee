# Module dependencies.
fs = require('fs')
wrench = require('wrench')
AdmZip = require('adm-zip')

fileHandler =
  move: (currentLoc, destinationLoc) ->
    fs.rename currentLoc, destinationLoc
  
  moveDir: (currentLoc, destinationLoc) ->
    fs.mkdir destinationLoc
    @move currentLoc, destinationLoc

  compress: (dir) ->
    zip = new AdmZip()
    zip.addLocalFolder dir
    zip.writeZip dir + '.zip'

  removeDir: (dir) ->
    opts =
      forceDelete: true
    wrench.rmdirSyncRecursive dir, opts 

# Expose
module.exports = fileHandler

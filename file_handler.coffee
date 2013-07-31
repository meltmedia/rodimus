# Module dependencies.
fs = require('fs')
wrench = require('wrench')
AdmZip = require('adm-zip')

zip = new AdmZip()

fileHandler =
  move: (currentLoc, destinationLoc) ->
    fs.rename currentLoc, destinationLoc
  
  moveDir: (currentLoc, destinationLoc) ->
    fs.mkdir destinationLoc
    @move (currentLoc, destinationLoc)

  compress: (dir) ->
    zip.addLocalFolder dir 
    zip.writeZip dir + '.zip'

  removeDir: (dir) ->
    wrench.rmdirSyncRecursive dir

# Expose
module.exports = fileHandler

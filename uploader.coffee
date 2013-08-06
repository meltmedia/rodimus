# Module dependencies.
fs = require('fs')

# File dependencies
fileHandler = require('./file_handler')

class Uploader
  # Constructor
  constructor: (@req, @callback) ->
    @initVars()
 
    # move the file to the intended location
#   fs.mkdir @target_dir
    fileHandler.move @tmp_path, @target_dir
 
    @callback @uniq_dir

  initVars: () ->
    @tmp_path = @req.files.document.path
    @uniq_dir = @tmp_path.split('/')[2]
    @target_dir = './public/docs/' + @uniq_dir
    @target_path = @target_dir + '/file.docx'

# Expose
module.exports = Uploader

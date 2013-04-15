form action:'/file-upload', enctype:'multipart/form-data', method:'post', ->
  label for:'document', ->
    text 'Upload your file to transform'
  input type:'file', name:'document'
  input type:'submit', value:'Transform'

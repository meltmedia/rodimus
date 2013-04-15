
/**
 * Module dependencies.
 */

var express = require('express'),
    http = require('http'),
    fs = require('fs');

var app = express();

// all environments
app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  //app.enable('view cache');
  
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

// Routes
app.get('/', function(req, res){
  res.render('home', {title: 'Rodimus'});
});

app.get('/:uniq_dir', function(req, res){
  res.render('transforming', {title: 'Rodimus is transforming your document.'});
  res.send('File uploaded to: public/docs/' + req.params.uniq_dir + req.files.document.name + ' - ' + req.files.document.size + ' bytes');
});

/*
app.post('/file-upload', function(req, res, next) {
  console.log(req.body);
  console.log(req.files);
});
*/

// upload handler
app.post('/file-upload', function(req, res) {
  // get the temporary location of the file
  var tmp_path = req.files.document.path;
  var uniq_dir = tmp_path.split('/')[2];
  // set where the file should actually exist
  var target_path = './public/docs/' + uniq_dir + '/' + req.files.document.name;
  fs.mkdir('./public/docs/' + uniq_dir);
  // move the file to the intended location
  fs.rename(tmp_path, target_path, function(err) {
    if (err) console.log(err);
    // delete the temporary file
    fs.unlink(tmp_path, function() {
      if (err) throw err;
      //res.send('File uploaded to: ' + target_path + ' - ' + req.files.document.size + ' bytes');
      res.redirect('/' + uniq_dir);
    });
  });
});

// development only
http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

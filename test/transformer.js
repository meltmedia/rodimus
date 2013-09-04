var Transformer = require('../out/transformer.js'),
    assert = require('assert');

suite('Transformer', function(){

  test('initVars', function(){
    var optimus = new Transformer('1234', function(){});

    assert.strictEqual(optimus.doc, 'public/docs/1234/file.docx');
  });

});

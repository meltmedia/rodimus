module.exports = function(grunt) {

  grunt.initConfig({
  	pkg: grunt.file.readJSON('package.json'),

    mocha: {
      index: [ 'test/index.html' ]
    },

    exec: {
      run: {
        cmd: 'npm start'
      },
    },

    groc: {
      options: {
        out: 'docs/'
      }
    },

  });

  grunt.loadNpmTasks('grunt-exec');
  grunt.loadNpmTasks('grunt-mocha');
  grunt.loadNpmTasks('grunt-groc');
  grunt.loadNpmTasks('grunt-node-version');

  grunt.registerTask('docs', ['groc']);
  grunt.registerTask('run', ['node_version','exec:run']);
};

module.exports = function(grunt) {

  grunt.initConfig({
  	pkg: grunt.file.readJSON('package.json'),

    coffee: {
      glob_to_multiple: {
        expand: true,
        src: ['*.coffee'],
        dest: 'out/',
        ext: '.js'
      }
    },

    mocha: {
      index: {
        src: ['test/*.js']
      }
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

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-exec');
  grunt.loadNpmTasks('grunt-mocha');
  grunt.loadNpmTasks('grunt-groc');
  grunt.loadNpmTasks('grunt-node-version');

  grunt.registerTask('docs', ['groc']);
  grunt.registerTask('test', ['node_version', 'coffee', 'mocha']);
  grunt.registerTask('run', ['node_version','exec:run']);
};

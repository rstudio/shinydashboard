module.exports = function(grunt) {

  var srcdir = '../inst/';

  grunt.initConfig({
    pkg: pkgInfo(),
    uglify: {
      adminlte: {
        options: {
          sourceMap: true
        },
        src: srcdir + '/AdminLTE/app.js',
        dest: srcdir + '/AdminLTE/app.min.js'
      }
    },

    cssmin: {
      adminlte: {
        src: srcdir + '/AdminLTE/AdminLTE.css',
        dest: srcdir + '/AdminLTE/AdminLTE.min.css'
      },
      adminlte_themes: {
        src: srcdir + '/AdminLTE/_all-skins.css',
        dest: srcdir + '/AdminLTE/_all-skins.min.css'
      }
    },

    jshint: {
      options: {
        force: true  // Don't abort if there are JSHint warnings
      },
      shinydashboard: {
        src: srcdir + '/shinydashboard.js',
      }
    },

    watch: {
      shinydashboard: {
        files: '<%= jshint.shinydashboard.src %>',
        tasks: ['newer:jshint:shinydashboard']
      },
      adminlte: {
        files: ['<%= uglify.adminlte.src %>', '<%= cssmin.adminlte.src %>'],
        tasks: ['newer:uglify:adminlte', 'newer:cssmin:adminlte']
      }
    }
  });


  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-newer');


  grunt.registerTask('default', ['newer:uglify', 'newer:cssmin', 'newer:jshint']);



  // Return an object which merges information from package.json and the
  // DESCRIPTION file.
  function pkgInfo() {
    var pkg = grunt.file.readJSON('package.json');

    pkg.name    = descKeyValue('Package');
    pkg.version = descKeyValue('Version');
    pkg.license = descKeyValue('License');

    return pkg;
  }

  // From the DESCRIPTION file, get the value of a key. This presently only
  // works if the value is on one line, the same line as the key.
  function descKeyValue(key) {
    var lines = require('fs').readFileSync('../DESCRIPTION', 'utf8').split('\n');

    var pattern = new RegExp('^' + key + ':');
    var txt = lines.filter(function(line) {
      return pattern.test(line);
    });

    txt = txt[0];

    pattern = new RegExp(key + ': *');
    txt = txt.replace(pattern, '');

    return txt;
  }
};


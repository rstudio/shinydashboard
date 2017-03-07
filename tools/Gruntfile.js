module.exports = function(grunt) {

  var srcdirjs = '../srcjs/';
  var srcdircss = '../inst/';
  var destdirjs = '../inst/';
  var destdircss = '../inst/';

  grunt.initConfig({
    pkg: pkgInfo(),

    clean: {
      options: { force: true },
      src: [
        destdirjs + "shinydashboard.js",
        destdirjs + "shinydashboard.js.map",
        destdirjs + "shinydashboard.min.js",
        destdirjs + "shinydashboard.min.js.map",
        destdirjs + "AdminLTE/app.js",
        destdirjs + "AdminLTE/app.js.map",
        destdirjs + "AdminLTE/app.min.js",
        destdirjs + "AdminLTE/app.min.js.map",
        destdircss + "AdminLTE/AdminLTE.min.css",
        destdircss + "AdminLTE/_all-skins.min.css",
      ]
    },

    concat: {
      options: {
        process: function(src, filepath) {
          return '//---------------------------------------------------------------------\n' +
            '// Source file: ' + filepath + '\n\n' + src;
        },
        sourceMap: true
      },
      shinydashboard: {
        src: [
          srcdirjs + '_start.js',
          srcdirjs + 'shinydashboard-part.js',
          srcdirjs + '_end.js'
        ],
        dest: destdirjs + 'shinydashboard.js'
      },
      adminlte: {
        src: [
          srcdirjs + 'AdminLTE/app.js'
        ],
        dest: destdirjs + 'AdminLTE/app.js'
      }
    },

    uglify: {
      shinydashboard: {
        options: {
          banner: '/*! <%= pkg.name %> <%= pkg.version %> | ' +
                  '(c) 2017-<%= grunt.template.today("yyyy") %> RStudio, Inc. | ' +
                  'License: <%= pkg.license %> */\n',
          sourceMap: true,
          // Base the .min.js sourcemap off of the .js sourcemap created by concat
          sourceMapIn: destdirjs + 'shinydashboard.js.map',
          sourceMapIncludeSources: true
        },
        src: destdirjs + 'shinydashboard.js',
        dest: destdirjs + 'shinydashboard.min.js'
      },
      adminlte: {
        options: {
          sourceMap: true
        },
        src: srcdirjs + 'AdminLTE/app.js',
        dest: destdirjs + 'AdminLTE/app.min.js'
      }
    },

    cssmin: {
      adminlte: {
        src: srcdircss + 'AdminLTE/AdminLTE.css',
        dest: destdircss + 'AdminLTE/AdminLTE.min.css'
      },
      adminlte_themes: {
        src: srcdircss + 'AdminLTE/_all-skins.css',
        dest: destdircss + 'AdminLTE/_all-skins.min.css'
      }
    },

    jshint: {
      options: {
        force: true  // Don't abort if there are JSHint warnings
      },
      shinydashboard: destdirjs + "shinydashboard.js",
    },

    watch: {
      shinydashboard: {
        files: '<%= concat.shinydashboard.src %>',
        tasks: ['concat:shinydashboard', 'uglify:shinydashboard', 'jshint:shinydashboard']
      },
      adminlte: {
        files: ['<%= uglify.adminlte.src %>', '<%= cssmin.adminlte.src %>'],
        tasks: ['uglify:adminlte', 'cssmin:adminlte']
      }
    }
  });


  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-newer');


  grunt.registerTask('default', ['concat', 'uglify', 'cssmin', 'jshint']);


  // ---------------------------------------------------------------------------
  // Utility functions
  // ---------------------------------------------------------------------------

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


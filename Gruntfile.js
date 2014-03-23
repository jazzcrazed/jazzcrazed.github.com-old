module.exports = function(grunt) {
  grunt.initConfig({
    cssmin: {
      production: {
        expand: true,
        cwd: 'css',
        src: ['*.css'],
        dest: 'css'
      }
    },
    coffee: {
      preview: {
        sourceMap: true,
        files: {
          'contents/js/script.js': ['contents/coffee/*.coffee']
        }
      },
      production: {
        sourceMap: false,
        files: {
          'contents/js/script.js': ['contents/coffee/*.coffee']
        }
      }
    },
    compass: {
      dist: {
        options: {
          sassDir: 'contents/sass',
          cssDir: 'css',
          environment: 'production'
        }
      },
      dev: {
        options: {
          sassDir: 'contents/sass',
          cssDir: 'contents/css',
          environment: 'development'
        }
      }
    },
    extend: {
      options: {
        deep: true,
        defaults: grunt.file.readJSON('config.json')
      },
      production: {
        files: {
          './config-production.json': ['./config-production-base.json']
        }
      },
      preview: {
        files: {
          './config-preview.json': ['./config-preview-base.json']
        }
      }
    },
    wintersmith: {
      production: {
        options: {
          config: './config-production.json'
        }
      },
      preview: {
        options: {
          action: "preview",
          config: './config-preview.json'
        }
      }
    },
    watch: {
      sass: {
        files: [
          'contents/sass/**/*.scss'
        ],
        tasks: [
          'compass:dev'
        ]
      },
      coffeescript: {
        files: [
          'contents/coffee/**/*.coffee'
        ],
        tasks: [
          'coffee:preview'
        ]
      }
    },
    uglify: {
      production: {
        files: {
          'js/script.js': 'js/script.js'
        }
      }
    },
  });
  grunt.loadNpmTasks("grunt-extend");
  grunt.loadNpmTasks("grunt-contrib-coffee");
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-wintersmith');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.registerTask('preview', [
    'extend:preview',
    'coffee:preview',
    'compass:dev',
    'wintersmith:preview'
  ]);
  grunt.registerTask('buildProduction', [
    'extend:production',
    'coffee:production',
    'compass:dist',
    'wintersmith:production',
    'uglify:production',
    'cssmin:production'
  ]);
};

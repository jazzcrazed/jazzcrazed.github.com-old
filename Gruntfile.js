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
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-wintersmith');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.registerTask('preview', [
    'compass:dev',
    'wintersmith:preview'
  ]);
  grunt.registerTask('buildProduction', [
    'compass:dist',
    'wintersmith:production',
    'uglify:production',
    'cssmin:production'
  ]);
};

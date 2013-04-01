'use strict'
path = require 'path'
lrsnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

folderMount = (connect, point) ->
  connect.static path.resolve(point)

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    cfg: grunt.file.readYAML 'grunt-config.yml'

    clean:
      production: ['<%= cfg.outdir.prod %>']

    version:
      pkgfiles:
        src: ['package.json']
      compfiles:
        src: ['component.json']

    coffeelint:
      app: ['app/**/*.coffee']
      # tests: 
      #   files:
      #     src: ['test/*.coffee']
      options:
        no_trailing_whitespaces:
          level: 'error'
    
    coffee:
      development:
        files:
          '<%= cfg.outdir.dev %>/js/app-<%= pkg.version %>.js': ['app/**/*.coffee']
      production:
        files:
          '<%= cfg.outdir.prod %>/js/app.js': ['app/**/*.coffee']
    
    concat:
      vendor: #TODO: replace with include (from json, yaml, or `bower list`)
        dest: '<%= cfg.outdir.dev %>/js/vendor-<%= pkg.version %>.js'
        src: '<%= cfg.src.js.vendor %>'

    less:
      development:
        options:
          paths: ['app/styles', 'components']
        files: 
          '<%= cfg.outdir.dev %>/css/app-<%= pkg.version %>.css': 'app/styles/app.less'
      production:
        options:
          paths: ['app/styles', 'components']
        files: 
          '<%= cfg.outdir.prod %>/css/app.css': 'app/styles/app.less'

    jade:
      development:
        options:
          pretty: true
        files: [
          expand: true
          cwd: 'app/'
          src: ['**/*.jade']
          dest: '<%= cfg.outdir.dev %>/'
          ext: '.html'
        ]
      production:
        files: [
          expand: true
          cwd: 'app/'
          src: ['**/*.jade']
          dest: '<%= cfg.outdir.prod %>'
          ext: '.html'
        ]

    copy:
      development:
        files: [ 
          { expand: yes, cwd: 'app/font/', src: ['**'], dest: '<%= cfg.outdir.dev %>/font/' }
          { expand: yes, cwd: 'app/images/', src: ['**'], dest: '<%= cfg.outdir.dev %>/images/' }
        ]
      production:
        files: [
          { expand: yes, cwd: 'app/font/', src: ['**'], dest: '<%= cfg.outdir.prod %>/font/' }
        ]

    imagemin:
      production:
        options:
          optimizationLevel: 7
        files: [
          { expand: yes, cwd: 'app/images/', src: ['**'], dest: '<%= cfg.outdir.prod %>/images/' }
        ]

    uglify:
      options:
        mangle:
          except: '<%= cfg.nomangle %>'
      production:
        files:
          '<%= cfg.outdir.prod %>/js/app-<%= pkg.version %>.js': ['<%= cfg.outdir.prod %>/js/app.js']
          '<%= cfg.outdir.prod %>/js/vendor-<%= pkg.version %>.js': '<%= cfg.src.js.vendor %>'

    cssmin:
      production:
        files:
          '<%= cfg.outdir.prod %>/css/app-<%= pkg.version %>.css': ['<%= cfg.outdir.prod %>/css/app.css']

    replace:
      development:
        options:
          variables:
            'version': '<%= pkg.version %>'
        files: [
          {src: ['<%= cfg.outdir.dev %>/index.html'], dest: '<%= cfg.outdir.dev %>/index.html'}
        ]
      production:
        options:
          variables:
            'version': '<%= pkg.version %>'
        files: [
          {src: ['<%= cfg.outdir.prod %>/index.html'], dest: '<%= cfg.outdir.prod %>/index.html'}
        ]

    testacular:
      unit:
        options:
          configFile: 'testacular.conf.js'
          browsers: if process.env.TRAVIS then ['Firefox', 'PhantomJS'] else ['PhantomJS']
          autoWatch: yes
          keepalive: yes
          singleRun: yes
    
    testacularRun:
      unit:
        options:
          runnerPort: 9100

    connect:
      livereload:
        options:
          port: 3333
          hostname: '0.0.0.0'
          middleware: (connect, options) ->
            [lrsnippet, folderMount(connect, './_dev_public')]
      production:
        options:
          port: 3333
          hostname: '0.0.0.0'
          middleware: (connect, options) ->
            [folderMount(connect, './<%= cfg.outdir.prod %>')]

    regarde: #TODO: make this taks immune to errors in subtasks
      buildcss:
        files: ['app/**/*.less', 'app/**/*.sass', 'app/**/*.scss']
        tasks: ['less:development'] #TODO: add SASS, Compass, and copy css tasks
      buildother:
        files: ['app/**', '!app/**/*.less', '!app/**/*.sass', '!app/**/*.scss']
        tasks: ['lint', 'build:dev']
      js:
        files: '<%= cfg.outdir.dev %>/**/*.js'
        tasks: ['livereload']
      css:
        files: '<%= cfg.outdir.dev %>/**/*.css'
        tasks: ['livereload']
      html:
        files: '<%= cfg.outdir.dev %>/**/*.html'
        tasks: ['livereload']


  ### Vendor Tasks ###
  #Prep & Admin
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-version'

  # Linting
  grunt.loadNpmTasks 'grunt-coffeelint'
  #grunt.loadNpmTasks 'grunt-contrib-jshint'

  # Building
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  # Testing (Dev)
  grunt.loadNpmTasks 'grunt-testacular'
  
  # Optimization (Prod)
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-compress'

  #cache bust
  grunt.loadNpmTasks 'grunt-replace'

  # Static Server & LiveReload (Dev)
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-contrib-livereload'

  
  ### CUSTOM TASKS ###
  grunt.registerTask 'lint', [
    'coffeelint'
  ]
  grunt.registerTask 'build:dev', [
    'lint'
    'coffee:development'
    'concat'
    'less:development'
    'jade:development'
    'copy:development'
    'replace:development'
  ]
  grunt.registerTask 'build:prod', [
    'lint'
    'clean:production'
    'coffee:production'
    'less:production'
    'jade:production'
    'copy:production'
    'imagemin:production'
    'uglify:production'
    'cssmin:production'
    'replace:production'
  ]
  #TODO: grunt.registerTask 'test', []
  grunt.registerTask 'default', [
    'build:dev'
    'livereload-start'
    'connect:livereload'
    'regarde'
  ]
  grunt.registerTask 'prodweb', [
    'connect:production'
    'regarde'
  ]

  # TODO: Task (possibly custom) to add cache busting sigs to files
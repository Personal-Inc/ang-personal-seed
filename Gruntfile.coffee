'use strict'
require 'js-yaml'
path = require 'path'
cfg = require './grunt-config.yml'
lrsnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

folderMount = (connect, point) ->
  connect.static path.resolve(point)

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    cfg: grunt.file.readYAML 'grunt-config.yml'
    const:
      cssexts: 'less,sass,scss'

    clean:
      production: ['<%= cfg.outdir.prod %>']
      development: ['<%= cfg.outdir.dev %>']

    version:
      pkgfiles:
        src: ['package.json']
      compfiles:
        src: ['component.json']

    coffeelint:
      app: ['app/**/*.coffee']
      # tests: 
      #   files:
      #     src: ['test/**/*.coffee']
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
      vendor:
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
          { expand: yes, cwd: 'app/json/', src: ['**'], dest: '<%= cfg.outdir.dev %>/json/' }
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
            [lrsnippet, folderMount(connect, "./#{cfg.outdir.dev}")]
      production:
        options:
          port: 3333
          hostname: '0.0.0.0'
          middleware: (connect, options) ->
            [folderMount(connect, "./#{cfg.outdir.prod}")]

    regarde: #TODO: make this task immune to errors in subtasks, only rebuild changed components
      buildcss:
        files: ['app/**/*.{<%= const.cssexts %>}']
        tasks: ['less:development'] #TODO: add SASS, Compass, and copy css tasks
      buildother:
        files: ['app/**/*.*', '!app/**/*.{<%= const.cssexts %>}']
        tasks: ['build:dev']
      built:
        files: '<%= cfg.outdir.dev %>/**'
        tasks: ['livereload']


  ### Process Custom Asset Directories ###
  cssExts = grunt.config 'const.cssexts'
  
  cfgArr = [
    'regarde.buildother.files'
    'regarde.buildcss.files'
    'coffeelint.app'
    'jade.development.files'
  ]

  for own k,v of grunt.config 'coffee.development.files'
    coffeeDevKey = "coffee.development.files.#{grunt.config.escape k}"
  for own k,v of grunt.config 'coffee.production.files'
    coffeeProdKey = "coffee.production.files.#{grunt.config.escape k}"
  cfgArr.push coffeeDevKey
  cfgArr.push coffeeProdKey

  #TODO: LESS
  #TODO: IMAGES
  #TODO: COPY TASKS

  cfgObj = {}
  cfgObj[cfgName] = grunt.config cfgName for cfgName in cfgArr

  if grunt.config('cfg.assetdirs')?.length?
    for dir in grunt.config 'cfg.assetdirs'
      cfgObj['regarde.buildcss.files'].push "#{dir}/**/*.{#{cssExts}}"
      cfgObj['regarde.buildother.files'].push "#{dir}/**/*.*"
      cfgObj['regarde.buildother.files'].push "!#{dir}/**/*.{#{cssExts}}"
      cfgObj['coffeelint.app'].push "#{dir}/**/*.coffee"
      cfgObj[coffeeDevKey].push "#{dir}/**/*.coffee"
      cfgObj[coffeeProdKey].push "#{dir}/**/*.coffee"
      cfgObj['jade.development.files'].push 
        expand: yes
        cwd: "#{dir}/"
        src: ['**/*.jade']
        dest: '<%= cfg.outdir.dev %>/'
        ext: '.html'

  
  grunt.config cfgName, cfgVal for own cfgName, cfgVal of cfgObj
  
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
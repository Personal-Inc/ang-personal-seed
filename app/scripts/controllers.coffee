'use strict'

### Controllers ###

angular.module('app.controllers', [])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'
  '$cookies'
  '$http'
  '$route'

($scope, $location, $resource, $rootScope, $cookies, $http, $route) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  # getClass compares the current url with the id.
  # If the current url starts with the id it returns 'active'
  # otherwise it will return '' an empty string. E.g.
  #
  #   # current url = '/products/1'
  #   getClass('/products') # returns 'active'
  #   getClass('/orders') # returns ''
  #
  $scope.getClass = (id) ->
    if $scope.activeNavId.substring(0, id.length) == id
      return 'active'
    else
      return ''
])

.controller('CarouselCtrl', [
  '$scope'

($scope) ->

  # Uses the url to determine if the selected
  $scope.sections = [
    template: 'intro'
  ,
    template: 'install'
  ,
    template: 'configure'
  ,
    template: '4'
  ,
    template: '5'
  ,
    template: '6'
  ,
    template: '7'
  ,
    template: '8'
  ,
    template: '9'
  ]

  rotation = 360 / $scope.sections.length
  tz =  Math.round( ( 410 / 2 ) / Math.tan(Math.PI / $scope.sections.length) )

  sec.rotateY = i * rotation for sec, i in $scope.sections
  $scope.translateZ = tz
  $scope.rotation = rotation
  $scope.currIdx = 0

  $scope.incIdx = ->
    $scope.currIdx = $scope.currIdx + 1

  $scope.decIdx = ->
    $scope.currIdx = $scope.currIdx - 1
])
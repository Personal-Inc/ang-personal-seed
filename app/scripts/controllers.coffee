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


.controller('FunOgi', [
  '$scope'
  'Contact'

($scope, Contact) ->
  $scope.contacts = Contact.query {limit:80}
  $scope.saveOgi = (contact) ->
    console.log(contact)
    #contact.$save()
])

.controller('CreateAndShare', [
  '$scope'
  'Gem'
  'Schema'

($scope, Gem, Schema) ->
 Gem.query {temp_id:'0001'}, (gemList) ->
   $scope.gemList = gemList
   $scope.gem = gemList[0] if gemList.length > 0
   $scope.gem = new Gem({}) if gemList.length == 0
   
   $scope.saveGem = (gem) ->
     gem.$save() unless gem.info.gem_instance_id?
     gem.$update() if gem.info.gem_instance_id?
   $scope.shareGem = (gem, contacts) ->
     gem.$save() unless gem.info.gem_instance_id?
     gem.$update() if gem.info.gem_instance_id?
     gem.$share(contacts)

])
.controller('FunCtrl', [
  '$scope'
  'Contact'
  'Gem'
  'Schema'

($scope, Contact, Gem, Schema) ->
 $scope.mycontacts = Contact.query {limit:80}
 $scope.mygems = Gem.query()
 $scope.profileMap = Schema.getProfileMap()
 
])
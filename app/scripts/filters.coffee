'use strict'

### Filters ###

angular.module('app.filters', [])

.filter('avatarId', [
 ()->
  (contact)->
   contact.id.split('#')[1]
])

.filter('interpolate', [
    'version',

    (version) ->
        (text) ->
            String(text).replace(/\%VERSION\%/mg, version)
])
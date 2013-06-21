'use strict'

### Filters ###

angular.module('app.filters', [])

.filter('mineGem', [
 ()->
  (gemList, contact)->
     gemList.filter (gem, idx, arr) ->
       gem.info.gem_instance_id.split('#')[0] == contact.id.split('#')[1]
])


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
'use strict'

### Services ###
svc = angular.module('app.services', ['ngResource', 'app.filters'])

svc.factory 'version', -> "0.1.0"
'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
  'personal.controllers'
  'personal.directives'
  'personal.filters'
  'personal.services'
])

App.config([
  '$routeProvider'
  '$locationProvider'

($routeProvider, $locationProvider, config) ->

  $routeProvider

    .when('/contacts', {templateUrl: 'partials/contacts.html'})
  #   .when('/career', {templateUrl: 'partials/career.html'})
  #   .when('/login-popup', {templateUrl: 'partials/login-popup.html'})
  #   .when(LOGIN_URL, {templateUrl: LOGIN_TEMPLATE})

  #   # Catch all
    .otherwise({redirectTo: '/contacts'})

  # Without server side support html5 must be disabled.
  $locationProvider.html5Mode(false)
])
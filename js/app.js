(function() {
  'use strict';
  var App;

  App = angular.module('app', ['ngCookies', 'ngResource', 'app.controllers', 'app.directives', 'app.filters', 'app.services']);

  App.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider, config) {
      $routeProvider.when('/carousel', {
        templateUrl: 'partials/carousel.html'
      }).otherwise({
        redirectTo: '/carousel'
      });
      return $locationProvider.html5Mode(false);
    }
  ]);

}).call(this);

(function() {
  angular.element(document).ready(function() {
    return angular.bootstrap(document, ['app']);
  });

}).call(this);

(function() {
  'use strict';
  /* Controllers
  */
  angular.module('app.controllers', []).controller('AppCtrl', [
    '$scope', '$location', '$resource', '$rootScope', '$cookies', '$http', '$route', function($scope, $location, $resource, $rootScope, $cookies, $http, $route) {
      $scope.$location = $location;
      $scope.$watch('$location.path()', function(path) {
        return $scope.activeNavId = path || '/';
      });
      return $scope.getClass = function(id) {
        if ($scope.activeNavId.substring(0, id.length) === id) {
          return 'active';
        } else {
          return '';
        }
      };
    }
  ]).controller('CarouselCtrl', [
    '$scope', function($scope) {
      var i, rotation, sec, tz, _i, _len, _ref;

      $scope.sections = [
        {
          template: 'intro'
        }, {
          template: 'install'
        }, {
          template: 'configure'
        }, {
          template: '4'
        }, {
          template: '5'
        }, {
          template: '6'
        }, {
          template: '7'
        }, {
          template: '8'
        }, {
          template: '9'
        }
      ];
      rotation = 360 / $scope.sections.length;
      tz = Math.round((410 / 2) / Math.tan(Math.PI / $scope.sections.length));
      _ref = $scope.sections;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        sec = _ref[i];
        sec.rotateY = i * rotation;
      }
      $scope.translateZ = tz;
      $scope.rotation = rotation;
      $scope.currIdx = 0;
      $scope.incIdx = function() {
        return $scope.currIdx = $scope.currIdx + 1;
      };
      return $scope.decIdx = function() {
        return $scope.currIdx = $scope.currIdx - 1;
      };
    }
  ]);

}).call(this);

(function() {
  'use strict';
  /* Directives
  */

  var app_dir;

  app_dir = angular.module('app.directives', ['app.services']);

  app_dir.directive('appVersion', [
    'version', function(version) {
      return function(scope, elm, attrs) {
        return elm.text(version);
      };
    }
  ]);

  app_dir.directive('bsPopover', [
    'version', function(version) {
      return {
        priority: 0,
        restrict: 'A',
        link: function(scope, elem, attr) {
          scope.$watch(attr.bsPopover, function(val) {
            if (val == null) {
              return;
            }
            elem.popover();
            if (attr.bsPeek === 'true') {
              return setTimeout(function() {
                elem.popover('show');
                return setTimeout(function() {
                  return elem.popover('hide');
                }, 2000);
              }, 500);
            }
          });
        }
      };
    }
  ]);

  app_dir.directive('bsTooltip', [
    'version', function(version) {
      return {
        priority: 0,
        restrict: 'A',
        link: function(scope, elem, attr) {
          scope.$watch(attr.title, function(val) {});
          elem.tooltip();
        }
      };
    }
  ]);

}).call(this);

(function() {
  'use strict';
  /* Filters
  */
  angular.module('app.filters', []).filter('interpolate', [
    'version', function(version) {
      return function(text) {
        return String(text).replace(/\%VERSION\%/mg, version);
      };
    }
  ]);

}).call(this);

(function() {
  'use strict';
  /* Services
  */

  var svc;

  svc = angular.module('app.services', ['ngResource', 'app.filters']);

  svc.factory('version', function() {
    return "0.1.0";
  });

}).call(this);

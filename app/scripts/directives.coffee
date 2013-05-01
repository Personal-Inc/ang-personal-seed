'use strict'

### Directives ###

# register the module with Angular
app_dir = angular.module('app.directives', [
    # require the 'app.service' module
    'app.services'
])

app_dir.directive('appVersion', [
    'version'

(version) ->

    (scope, elm, attrs) ->
        elm.text(version)
])

# app_dir.directive('fwTransSize', [
#     'version'

# (version) ->

#     priority: -1000
#     restrict: 'A'
#     compile: (elem, attr, transclude) ->
#         jQuery(elem).css('overflow', 'hidden').wrapInner('<div></div>')
#         return {post: (scope, elem, attr) ->
#             scope.$watch attr.fwTransSize, (val) ->
#                 jQuery(elem).trigger 'resize'

#             elem.bind 'resize', (event) ->
#                 jq_self = jQuery(elem)
#                 jq_inner = jq_self.children()
#                 jq_self.height(jq_inner.height())

#             return
#         }
# ])
    
app_dir.directive('bsPopover', [
    'version'

(version) ->

    priority: 0
    restrict: 'A'
    link: (scope, elem, attr) ->
        scope.$watch attr.bsPopover, (val) ->
            if !val? then return
            elem.popover()
            if attr.bsPeek == 'true'
                setTimeout () ->
                    elem.popover 'show'
                    setTimeout () ->
                        elem.popover('hide')
                    , 2000
                , 500
        return
])

app_dir.directive('bsTooltip', [
    'version'

(version) ->

    priority: 0
    restrict: 'A'
    link: (scope, elem, attr) ->
        scope.$watch attr.title, (val) ->
        elem.tooltip()
        return
])
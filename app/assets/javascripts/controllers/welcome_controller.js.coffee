xplanWelcomeController = angular.module "xplanWelcomeController", [ ]

xplanWelcomeController.controller "welcomeController", [ '$scope', '$rootScope', '$timeout', '$state',  ($scope, $rootScope, $timeout, $state) ->
    $scope.goToSurvey = () ->
        $state.transitionTo "survey"
]
xplanControllers = angular.module "xplanControllers", [ ]
    
xplanControllers.controller "itemListController", [ '$scope', '$rootScope', 'XplanData', ($scope, $rootScope, XplanData) ->
    $scope.items = XplanData.items
    
    $scope.launchItemCreate = () ->
        $rootScope.$broadcast 'item.create'

    $scope.deleteItem = (item) ->
        XplanData.deleteItem item

    $scope.editItem = (item) ->
        $rootScope.$broadcast 'item.edit', item
]
    
xplanControllers.controller "itemCreationController", [ '$scope', '$rootScope', '$timeout', 'XplanData',  ($scope, $rootScope, $timeout, XplanData) ->
    $('#addItemModal').modal
        show: false

    $rootScope.$on "item.create", () ->
        $scope.item = null
        $('#addItemModal').modal "show"

    $rootScope.$on "item.edit", (event, item) ->
        $scope.item = item
        $('#addItemModal').modal "show"

    isUrl = (value) ->
        # http://stackoverflow.com/questions/5717093/check-if-a-javascript-string-is-an-url
        pattern = new RegExp '^(https?:\\/\\/)?' +
            '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|' +
            '((\\d{1,3}\\.){3}\\d{1,3}))' +
            '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' +
            '(\\?[;&a-z\\d%_.~+=-]*)?' +
            '(\\#[-a-z\\d_]*)?$','i'
        pattern.test value

    addAlert = (alertMessage) -> 
        $scope.alerts.push alertMessage
        $timeout () ->
            index = $scope.alerts.indexOf alertMessage
            $scope.alerts.splice index, 1
        , 5000

    addBookmark = (value) ->
        addAlert "Added '" + value + "' as a bookmark..."
        $scope.bookmarks.push value

    $scope.magicInput = () ->
        if isUrl($scope.magicValue)
            # If we have a URL add it as a bookmark
            addBookmark $scope.magicValue
            $scope.magicValue = ""
        else
            # Otherwise get suggestions from the server
            XplanData.suggest
                term: $scope.magicValue
            .then (response) ->
                $scope.suggestions = [ ]
                angular.forEach response.data.suggestions, (suggestion) ->
                    $scope.suggestions.push suggestion
    
    $scope.submitItem = () ->
        if $scope.item == null
            XplanData.createItem
                title: $scope.item_title
                details: $scope.item_details
        else
            XplanData.editItem $scope.item,
                title: $scope.item_title
                details: $scope.item_details

    $scope.buttonMessage = () ->
        if $scope.item != null
            "Edit"
        else
            "Add"

    $scope.bookmarks = [ ]
    $scope.alerts = [ ]
]

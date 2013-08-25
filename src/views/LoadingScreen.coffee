define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/ImageLoader"
], (Screen, Kinetic, Constants, ImageLoader) ->

    class LoadingScreen extends Screen

        LOADING_IMAGE_PERIOD = 2

        constructor: (manifest, callback) ->
            super()

            @_layer.add new Kinetic.Rect
                fill: "#000000"
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height

            @_layer.add new Kinetic.Rect
                name: "loading"
                stroke: Constants.COLORS.BACKGROUND
                strokeWidth: 5
                width:  Constants.TILE_SIZE
                height: Constants.TILE_SIZE
                x: Constants.RESOLUTION.width  - Constants.TILE_SIZE * Math.sqrt 2
                y: Constants.RESOLUTION.height - Constants.TILE_SIZE * Math.sqrt 2
                offsetX: Constants.TILE_SIZE / 2
                offsetY: Constants.TILE_SIZE / 2

            ImageLoader.addToList manifest
            ImageLoader.loadImages
                list: (list for list of manifest)
                completeCallback: callback

        update: (deltaTime) ->
            @_accumulatedTime ?= 0
            @_accumulatedTime += deltaTime / 1000
            @_accumulatedTime %= LOADING_IMAGE_PERIOD

            loadingImage = @_layer.get(".loading")[0]
            loadingImage.setRotation 2 * Math.PI * @_accumulatedTime / LOADING_IMAGE_PERIOD

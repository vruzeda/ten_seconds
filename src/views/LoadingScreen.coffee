define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/ImageLoader"
], (Screen, Kinetic, Constants, ImageLoader) ->

    class SplashScreen extends Screen

        LOADING_IMAGE_PERIOD = 2

        constructor: (manifest, callback) ->
            super()

            @_layer.add new Kinetic.Rect
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height
                fill: "black"

            loadingImage = ImageLoader.getImage "loading"
            @_layer.add new Kinetic.Image
                name: "loading"
                x: Constants.RESOLUTION.width  - loadingImage.width  * Math.sqrt 2
                y: Constants.RESOLUTION.height - loadingImage.height * Math.sqrt 2
                offsetX: loadingImage.width  / 2
                offsetY: loadingImage.height / 2
                image: loadingImage

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

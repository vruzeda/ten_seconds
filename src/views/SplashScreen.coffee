define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/ImageLoader"
    "views/LoadingScreen"
], (Screen, Kinetic, Constants, ImageLoader, LoadingScreen) ->

    class SplashScreen extends Screen

        constructor: (game) ->
            super game

            @_layer.add new Kinetic.Rect
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height
                fill: "black"

            ImageLoader.addToList
                LOADING_SCREEN:
                    loading: "images/loading/loading.png"

            ImageLoader.loadImages
                list: ["LOADING_SCREEN"]

                progressCallback: (total, complete, success) ->

                completeCallback: ->
                    game.switchScreen new LoadingScreen game

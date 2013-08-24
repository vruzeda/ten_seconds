define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/ImageLoader"
    "views/LoadingScreen"
    "views/MainScreen"
], (Screen, Kinetic, Constants, ImageLoader, LoadingScreen, MainScreen) ->

    class SplashScreen extends Screen

        constructor: (game) ->
            super()

            @_layer.add new Kinetic.Rect
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height
                fill: "black"

            ImageLoader.addToList
                LOADING_SCREEN:
                    loading: "images/loading/loading.png"

            ImageLoader.loadImages
                list: ["LOADING_SCREEN"]

                completeCallback: ->
                    mainScreenManifest =
                        MAIN_SCREEN:
                            mainBackground: "images/main/background.png"
                            mainPlayButton: "images/main/playbutton.png"

                    game.switchScreen new LoadingScreen mainScreenManifest, ->
                        game.switchScreen new MainScreen game

define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/ImageLoader"
    "views/LoadingScreen"
], (Screen, Kinetic, Constants, ImageLoader, LoadingScreen) ->

    class SplashScreen extends Screen

        constructor: (game) ->
            super()

            @_layer.add new Kinetic.Image
                image: ImageLoader.getImage "gameBackground"

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
                image: ImageLoader.getImage "mainBackground"

            mainPlayButton = ImageLoader.getImage "mainPlayButton"
            @_layer.add new Kinetic.Image
                name: "mainPlayButton"
                x: Constants.RESOLUTION.width  / 2
                y: Constants.RESOLUTION.height / 2
                offsetX: mainPlayButton.width  / 2
                offsetY: mainPlayButton.height / 2
                image: mainPlayButton

            @_configureButtons game

        _configureButtons: (game) ->
            mainPlayButton = @_layer.get(".mainPlayButton")[0]
            mainPlayButton.on "click tap", =>
                gameScreenManifest =
                    GAME_SCREEN:
                        gameBackground: "images/game/background.png"

                game.switchScreen new LoadingScreen gameScreenManifest, =>
                    console.log "Game screen!"

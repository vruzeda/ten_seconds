define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "views/LoadingScreen"
    "views/GameScreen"
    "models/levels/Levels"
], (Screen, Kinetic, Constants, LoadingScreen, GameScreen, Levels) ->

    class SplashScreen extends Screen

        constructor: (@_game) ->
            super()

            @_layer.add new Kinetic.Rect
                fill: "#000000"
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height

        update: (deltaTime) ->
            @_game.switchScreen new LoadingScreen {}, =>
                Levels.loadLevels =>
                    @_game.switchScreen new GameScreen @_game, Constants.FIRST_LEVEL

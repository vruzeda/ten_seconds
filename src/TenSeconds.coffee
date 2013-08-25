define [
    "Kinetic"
    "resources/Constants"
    "views/SplashScreen"
    "utils/InputController"
], (Kinetic, Constants, SplashScreen, InputController) ->

    class TenSeconds

        constructor: ->
            @_stage = @_createStage()
            @switchScreen @_createInitialScreen()

            gameLoopAnimation = new Kinetic.Animation @_gameLoop
            gameLoopAnimation.start()

        _createStage: ->
            # Just register the container
            InputController.createInstance "container"

            new Kinetic.Stage
                container: "container"
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height

        _createInitialScreen: ->
            new SplashScreen @

        _gameLoop: ({timeDiff: deltaTime}) =>
            @_update deltaTime
            @_redraw()

        _update: (deltaTime) ->
            @_screen.update deltaTime

        _redraw: ->
            @_screen.redraw()

        switchScreen: (screen) ->
            screen.show @_stage
            @_screen.hide @_stage if @_screen?
            @_screen = screen

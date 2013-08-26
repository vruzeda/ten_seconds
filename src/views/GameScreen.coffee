define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/InputController"
    "views/LoadingScreen"
    "models/maps/Map"
    "views/MapRenderer"
], (Screen, Kinetic, Constants, InputController, LoadingScreen, Map, MapRenderer) ->

    class GameScreen extends Screen

        constructor: (@_game, @_level) ->
            super()

            @_configureInputs()
            @_accumulatedTime = 0
            @_movingUp    = false
            @_movingDown  = false
            @_movingLeft  = false
            @_movingRight = false
            @_running     = false

            @_createLevel @_level

            @_needsRedraw = true

        _createLevel: (level) ->
            @_map = new Map level
            @_mapRenderer = new MapRenderer @_layer, @_map

            @_layer.add new Kinetic.Text
                name: "timer"
                text: "Safe"
                fontSize: 30
                fontFamily: "Calibri"
                fill: "#000000"
                align: "right"
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height

        _configureInputs: ->
            inputController = InputController.getInstance()
            inputController.addCharListener "W",     @_moveUp
            inputController.addCharListener "S",     @_moveDown
            inputController.addCharListener "A",     @_moveLeft
            inputController.addCharListener "D",     @_moveRight
            inputController.addCharListener "SHIFT", @_run

        _moveUp: (event) =>
            @_movingUp = @_checkEventType event

        _moveDown: (event) =>
            @_movingDown = @_checkEventType event

        _moveLeft: (event) =>
            @_movingLeft = @_checkEventType event

        _moveRight: (event) =>
            @_movingRight = @_checkEventType event

        _run: (event) =>
            @_running = @_checkEventType event

        _checkEventType: (event) ->
            event.type isnt "keyup"

        update: (deltaTime) ->
            @_accumulatedTime += deltaTime

            xIncrement = 0
            xIncrement++ if @_movingRight
            xIncrement-- if @_movingLeft

            yIncrement = 0
            yIncrement++ if @_movingDown
            yIncrement-- if @_movingUp

            @_characters ?= @_layer.get(".character")
            if @_characters.length > 0
                if xIncrement != 0 or yIncrement != 0
                    speed = Constants.CHARACTER_MOVEMENT.WALKING
                    speed = Constants.CHARACTER_MOVEMENT.RUNNING if @_running

                    @_moveCharactersTo @_characters, xIncrement, yIncrement, speed, deltaTime

                @_checkVictoryCondition @_characters

        _moveCharactersTo: (characters, xIncrement, yIncrement, speed, deltaTime) ->
            for character in characters
                @_moveCharacterTo character, xIncrement, yIncrement, speed, deltaTime

        _moveCharacterTo: (character, xIncrement, yIncrement, speed, deltaTime) ->
            actualSpeed =  speed
            actualSpeed = -speed if character.customData.isReflexive()

            originalX      = character.getX()
            originalY      = character.getY()
            originalRow    = Math.floor originalY / 32
            originalColumn = Math.floor originalX / 32

            desiredX       = originalX + xIncrement * deltaTime * actualSpeed / 1000
            desiredY       = originalY + yIncrement * deltaTime * actualSpeed / 1000
            desiredRow     = Math.floor desiredY / 32
            desiredColumn  = Math.floor desiredX / 32

            @_checkValidPosition character, originalRow, desiredColumn,  "x", desiredX
            @_checkValidPosition character, desiredRow,  originalColumn, "y", desiredY

        _checkValidPosition: (character, row, column, coordinate, position) ->
            object = @_map.getObjectAt row, column
            switch object.getName()
                when "empty", "character"
                    character.setAttr coordinate, position
                    @_needsRedraw = true

                when "trap"
                    @_resetLevel()

                when "portal"
                    targetLevel = object.targetLevel()
                    if targetLevel?
                        @_goToLevel targetLevel

                    else
                        @_nextLevel()

        _checkVictoryCondition: (characters) ->
            if characters.length == 1
                return

            else
                splitCharacters = 0

                for i in [0...characters.length]
                    split = true

                    for j in [i + 1...characters.length]
                        xDistance = characters[i].getX() - characters[j].getX()
                        yDistance = characters[i].getY() - characters[j].getY()

                        if 0.7 * Constants.TILE_SIZE > Math.sqrt xDistance * xDistance + yDistance * yDistance
                            split = false

                    if split
                        splitCharacters++

                    else
                        characters[i].remove()

                if splitCharacters == 1
                    @_nextLevel()

                else if @_accumulatedTime > 10000
                    @_resetLevel()

                else
                    @_timer ?= @_layer.get(".timer")[0]
                    currentTimer   = "Time warp in #{10 - Math.floor @_accumulatedTime / 1000}"
                    displayedTimer = @_timer.getText()
                    if displayedTimer != currentTimer
                        @_timer.setText currentTimer
                        @_needsRedraw = true

        _resetLevel: ->
            @_goToLevel @_level

        _nextLevel: ->
            @_goToLevel @_map.getNextLevel()

        _goToLevel: (levelFile) ->
            inputController = InputController.getInstance()
            inputController.removeAllCharListeners()

            @_game.switchScreen new LoadingScreen {}, =>
                @_game.switchScreen new GameScreen @_game, levelFile

        redraw: ->
            if @_needsRedraw
                @_layer.draw()
                @_needsRedraw = false

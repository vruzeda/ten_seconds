define [
    "views/Screen"
    "Kinetic"
    "resources/Constants"
    "utils/InputController"
    "views/LoadingScreen"
], (Screen, Kinetic, Constants, InputController, LoadingScreen) ->

    class GameScreen extends Screen

        LEVEL_SYMBOLS =
            0: "EMPTY"
            1: "TILE"
            2: "CHARACTER"
            3: "TRAP"
            4: "WARP"

        constructor: (@_game, @_levelFile) ->
            super()

            @_configureInputs()
            @_accumulatedTime = 0
            @_movingUp    = false
            @_movingDown  = false
            @_movingLeft  = false
            @_movingRight = false
            @_running     = false

            @_createLevel @_levelFile

        _createLevel: (levelFile) ->
            @_layer.removeChildren()

            require ["models/levels/#{levelFile}"], (@LEVEL) =>
                @_layer.add new Kinetic.Rect
                    fill:   Constants.COLORS.BACKGROUND
                    width:  Constants.RESOLUTION.width
                    height: Constants.RESOLUTION.height

                if @LEVEL.MESSAGE?
                    @_layer.add new Kinetic.Text @LEVEL.MESSAGE

                tilePositions      = []
                characterPositions = []
                trapPositions      = []
                warpPositions      = []

                for i in [0...@LEVEL.MAP.length]
                    for j in [0...@LEVEL.MAP[i].length]
                        switch LEVEL_SYMBOLS[@LEVEL.MAP[i][j]]
                            when "TILE"
                                tilePositions.push {i, j}

                            when "CHARACTER"
                                characterPositions.push {i, j}

                            when "TRAP"
                                trapPositions.push {i, j}

                            when "WARP"
                                warpPositions.push {i, j}

                for {i, j} in warpPositions
                    @_layer.add @_createObjectRect "warp", Constants.COLORS.WARP, i, j

                for {i, j} in trapPositions
                    @_layer.add @_createObjectRect "trap", Constants.COLORS.TRAP, i, j

                for {i, j} in characterPositions
                    @_layer.add @_createObjectRect "character", Constants.COLORS.CHARACTER, i, j

                for {i, j} in tilePositions
                    @_layer.add @_createObjectRect "tile", Constants.COLORS.TILE, i, j

        _createObjectRect: (name, fill, i, j) ->
            new Kinetic.Rect
                name: name
                fill: fill
                x: (j + 1 / 2) * Constants.TILE_SIZE
                y: (i + 1 / 2) * Constants.TILE_SIZE
                width:  Constants.TILE_SIZE
                height: Constants.TILE_SIZE
                offsetX: Constants.TILE_SIZE / 2
                offsetY: Constants.TILE_SIZE / 2

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

            characters = @_layer.get(".character")
            if characters.length > 0
                if xIncrement != 0 or yIncrement != 0
                    speed = Constants.CHARACTER_MOVEMENT.WALKING
                    speed = Constants.CHARACTER_MOVEMENT.RUNNING if @_running

                    @_moveCharactersTo characters, xIncrement, yIncrement, speed, deltaTime

                @_checkVictoryCondition characters

        _moveCharactersTo: (characters, xIncrement, yIncrement, speed, deltaTime) ->
            if characters.length == 1
                @_moveCharacterTo characters[0], xIncrement, yIncrement, speed, deltaTime

            else
                character0XIncrement = xIncrement
                character1XIncrement = xIncrement
                character1XIncrement = -xIncrement if @LEVEL.OPTIONS.REFLEXIVE

                @_moveCharacterTo characters[0], character0XIncrement, yIncrement, speed, deltaTime
                @_moveCharacterTo characters[1], character1XIncrement, yIncrement, speed, deltaTime

        _moveCharacterTo: (character, xIncrement, yIncrement, speed, deltaTime) ->
            originalX = character.getX()
            originalY = character.getY()
            originalI = Math.floor originalY / 32
            originalJ = Math.floor originalX / 32

            desiredX = originalX + xIncrement * deltaTime * speed / 1000
            desiredY = originalY + yIncrement * deltaTime * speed / 1000
            desiredI = Math.floor desiredY / 32
            desiredJ = Math.floor desiredX / 32

            @_checkValidPosition character, originalI, desiredJ,  "x", desiredX
            @_checkValidPosition character, desiredI,  originalJ, "y", desiredY

        _checkValidPosition: (character, i, j, coordinate, position) ->
            switch LEVEL_SYMBOLS[@LEVEL.MAP[i][j]]
                when "EMPTY", "CHARACTER"
                    character.setAttr coordinate, position

                when "TRAP"
                    @_resetLevel()

                when "WARP"
                    @_nextLevel()

        _checkVictoryCondition: (characters) ->
            return if characters.length == 1

            xDistance = Math.abs characters[0].getX() - characters[1].getX()
            yDistance = Math.abs characters[0].getY() - characters[1].getY()

            if xDistance < Constants.TILE_SIZE and yDistance < Constants.TILE_SIZE
                @_nextLevel()

            else if @_accumulatedTime > 10000
                @_resetLevel()

        _resetLevel: ->
            @_goToLevel @_levelFile

        _nextLevel: ->
            @_goToLevel @LEVEL.NEXT_LEVEL

        _goToLevel: (levelFile) ->
            inputController = InputController.getInstance()
            inputController.removeAllCharListeners()

            @_game.switchScreen new LoadingScreen {}, =>
                @_game.switchScreen new GameScreen @_game, levelFile


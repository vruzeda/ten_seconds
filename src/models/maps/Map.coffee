define [
    "models/levels/Levels"
    "models/objects/ObjectBuilder"
], (Levels, ObjectBuilder) ->

    class Map

        constructor: (level) ->
            Level = Levels.getLevel level

            @_message        = Level.MESSAGE
            @_messageOptions = Level.MESSAGE_OPTIONS

            @_nextLevel = Level.NEXT_LEVEL

            @_objects = []
            @_rows    = Level.MAP.length
            @_columns = Level.MAP[0].length

            for row in [0...@_rows]
                for column in [0...@_columns]
                    @_objects.push ObjectBuilder.buildObject Level.MAP[row][column], row, column, Level.SPECIAL

        getMessage: ->
            @_message ? []

        getMessageOptions: ->
            @_messageOptions ? {}

        getNextLevel: ->
            @_nextLevel

        getObjects: ->
            @_objects

        getObjectAt: (row, column) ->
            @_objects[row * @_columns  + column]

        update: (deltaTime) ->
            for object in @_objects when object?
                object.update deltaTime

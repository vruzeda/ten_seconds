define [
    "Kinetic"
    "resources/Constants"
], (Kinetic, Constants) ->

    class AbstractObject

        constructor: (@_name, @_fill, @_row, @_column) ->

        update: (deltaTime) ->
            # Do nothing

        getName: ->
            @_name

        getRow: ->
            @_row

        getColumn: ->
            @_column

        getNode: ->
            node = new Kinetic.Rect
                name:    @_name
                fill:    @_fill
                x:       Constants.TILE_SIZE * (1 / 2 + @_column)
                y:       Constants.TILE_SIZE * (1 / 2 + @_row)
                width:   Constants.TILE_SIZE
                height:  Constants.TILE_SIZE
                offsetX: Constants.TILE_SIZE / 2
                offsetY: Constants.TILE_SIZE / 2
            node.customData = @
            node



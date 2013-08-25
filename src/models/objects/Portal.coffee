define [
    "models/objects/AbstractObject"
], (AbstractObject, Kinetic) ->

    class Portal extends AbstractObject

        constructor: (row, column, options = {}) ->
            super "portal", "#0000FF", row, column
            @_fill        = options.fill if options.fill?
            @_targetLevel = options.targetLevel

        targetLevel: ->
            @_targetLevel

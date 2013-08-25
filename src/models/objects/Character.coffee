define [
    "models/objects/AbstractObject"
], (AbstractObject, Kinetic) ->

    class Character extends AbstractObject

        constructor: (row, column, options = {}) ->
            super "character", "#FF00FF", row, column
            @_reflexive = options.reflexive

        isReflexive: ->
            @_reflexive

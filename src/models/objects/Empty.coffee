define [
    "models/objects/AbstractObject"
], (AbstractObject, Kinetic) ->

    class Empty extends AbstractObject

        constructor: (row, column) ->
            super "empty", "#CCCCCC", row, column

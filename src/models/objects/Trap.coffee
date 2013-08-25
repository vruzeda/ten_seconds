define [
    "models/objects/AbstractObject"
], (AbstractObject, Kinetic) ->

    class Trap extends AbstractObject

        constructor: (row, column) ->
            super "trap", "#FF0000", row, column

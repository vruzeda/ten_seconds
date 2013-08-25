define [
    "models/objects/AbstractObject"
], (AbstractObject, Kinetic) ->

    class Wall extends AbstractObject

        constructor: (row, column) ->
            super "wall", "#FFFF00", row, column

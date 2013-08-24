define [
    "views/Screen"
    "Kinetic"
], (Screen, Kinetic) ->

    class SplashScreen extends Screen

        constructor: ->
            super()
            @_layer.add new Kinetic.Rect
                x: 239
                y: 75
                width: 100
                height: 50
                fill: "green"
                stroke: "black"
                strokeWidth: 4
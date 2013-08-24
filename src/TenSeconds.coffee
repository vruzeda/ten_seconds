define [
    "Kinetic"
    "resources/Constants"
], (Kinetic, Constants) ->

    class TenSeconds

        constructor: ->
            rect = new Kinetic.Rect
                x: 239
                y: 75
                width: 100
                height: 50
                fill: "green"
                stroke: "black"
                strokeWidth: 4

            layer = new Kinetic.Layer()
            layer.add rect

            stage = new Kinetic.Stage
                container: "container"
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height
            stage.add layer


define [
    "Kinetic"
    "resources/Constants"
], (Kinetic, Constants) ->

    class MapRenderer

        constructor: (@_layer, @_map) ->
            characters = []
            traps      = []
            walls      = []
            portals    = []

            for object in @_map.getObjects()
                switch object.getName()
                    when "character"
                        characters.push object

                    when "trap"
                        traps.push object

                    when "wall"
                        walls.push object

                    when "portal"
                        portals.push object

            @_layer.removeChildren()

            @_layer.add new Kinetic.Rect
                fill:   Constants.COLORS.BACKGROUND
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height

            message        = @_map.getMessage()
            messageOptions = @_map.getMessageOptions()

            @_layer.add new Kinetic.Text
                text: message.join "\n"
                fontSize: 30
                fontFamily: "Calibri"
                fill: "#FFFF00"
                align: "center"
                width:  Constants.RESOLUTION.width
                height: Constants.RESOLUTION.height
                x: messageOptions?.x ? 0
                y: messageOptions?.y ? 0

            @_layer.add object.getNode() for object in portals
            @_layer.add object.getNode() for object in traps
            @_layer.add object.getNode() for object in characters
            @_layer.add object.getNode() for object in walls

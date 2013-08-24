define [
    "Kinetic"
], (Kinetic) ->

    class Screen

        constructor: ->
            @_layer = @_createLayer()

        _createLayer: ->
            new Kinetic.Layer()

        show: (stage) ->
            stage.add @_layer

        hide: (stage) ->
            @_layer.remove()

        update: (deltaTime) ->
            # Do nothing!

        redraw: ->
            @_layer.draw()
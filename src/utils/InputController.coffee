define [], ->

    SPECIAL_BUTTONS =
        13: "ENTER"
        16: "SHIFT"
        37: "LEFT"
        38: "UP"
        39: "RIGHT"
        40: "DOWN"

    # Private class
    class InputControllerInstance

        CLICK_EVENTS = ["click", "tap"]

        constructor: (containerId) ->
            @_listeners = {}

            $("##{containerId}").css "outline", "none"
            $("##{containerId}").focus()
            $("##{containerId}").keydown (event) =>
                char = String.fromCharCode event.keyCode
                char = SPECIAL_BUTTONS[event.keyCode] if SPECIAL_BUTTONS[event.keyCode]?

                if @_listeners[char]?
                    listener event for listener in @_listeners[char]
                    return false

            $("##{containerId}").keyup (event) =>
                char = String.fromCharCode event.keyCode
                char = SPECIAL_BUTTONS[event.keyCode] if SPECIAL_BUTTONS[event.keyCode]?

                if @_listeners[char]?
                    listener event for listener in @_listeners[char]
                    return false

        ################
        # Mouse events #
        ################

        addClickListener: (node, listener) ->
            for clickEvent in CLICK_EVENTS
                node.on clickEvent, ->
                    listener node

        removeClickListener: (node, listener) ->
            for clickEvent in CLICK_EVENTS
                if node.eventListeners[clickEvent]?
                    listenerIndex = node.eventListeners[clickEvent].indexOf listener
                    if listenerIndex isnt -1
                        node.eventListeners[clickEvent].splice listenerIndex, 1

        removeClickListeners: (node) ->
            for clickEvent in CLICK_EVENTS
                node.off clickEvent

        ###################
        # Keyboard events #
        ###################

        addCharListener: (char, listener) ->
            @_listeners[char] ?= []
            @_listeners[char].push listener

        removeCharListener: (char, listener) ->
            if @_listeners[char]?
                listenerIndex = @_listeners[char].indexOf listener
                if listenerIndex isnt -1
                    @_listeners[char].splice listenerIndex, 1

        removeCharListeners: (char) ->
            if @_listeners[char]?
                while @_listeners[char].length > 0
                    @_listeners[char].pop()

                delete @_listeners[char]

        removeAllCharListeners: ->
            for key of @_listeners
                @removeCharListeners key



    class InputController

        @_instance = null

        @createInstance: (containerId) ->
            @_instance = new InputControllerInstance containerId

        @getInstance: ->
            @_instance

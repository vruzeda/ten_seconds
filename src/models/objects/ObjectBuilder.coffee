define [
    "models/objects/Empty"
    "models/objects/Character"
    "models/objects/Trap"
    "models/objects/Wall"
    "models/objects/Portal"
], (Empty, Character, Trap, Wall, Portal) ->

    class ObjectBuilder

        MAP_CODES =
            Empty:     /[ ]/
            Character: /[C]/
            Trap:      /[T]/
            Wall:      /[W]/
            Portal:    /[P]/
            Special:   /[0-9]/

        @buildObject: (mapCode, row, column, special) ->
            switch true
                when MAP_CODES.Empty.test mapCode
                    new Empty row, column

                when MAP_CODES.Character.test mapCode
                    new Character row, column

                when MAP_CODES.Trap.test mapCode
                    new Trap row, column

                when MAP_CODES.Wall.test mapCode
                    new Wall row, column

                when MAP_CODES.Portal.test mapCode
                    new Portal row, column

                when MAP_CODES.Special.test mapCode
                    Class   = special[mapCode].Class
                    options = special[mapCode].options

                    new Class row, column, options

                else
                    null

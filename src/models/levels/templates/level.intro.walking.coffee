define [
    "resources/Constants"
    "models/objects/Character"
], (Constants, Character) ->

    MESSAGE: [
        "Welcome."
        "If you still can't recall, this is your lab..."
        ""
        "And that Blue Portal over there is your life's work."
        "You scheduled an experiment for today, so go on,"
        "move that lazy body over there!"
        ""
        "(Move around using WASD)"
    ]
    MESSAGE_OPTIONS:
        y: 100

    NEXT_LEVEL: "level.intro.running"

    MAP:
        [
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "                                "
            "   WWWWWWWWWWWWWWWWWWWWWWWWWW   "
            "   W                        W   "
            "   W 0                    P W   "
            "   W                        W   "
            "   WWWWWWWWWWWWWWWWWWWWWWWWWW   "
            "                                "
            "                                "
            "                                "
        ]

    SPECIAL:
        0:
            Class: Character
            options:
                reflexive: false

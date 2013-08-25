define [
    "resources/Constants"
    "models/objects/Character"
], (Constants, Character) ->

    MESSAGE: [
        "You have to find your other half!\n\nMove around using WASD"
    ]
    MESSAGE_OPTIONS:
        y: 100

    NEXT_LEVEL: "level.8"

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
            "   WTTTTTTTTTTTTTTTTTTTTTTTTW   "
            "   W                        W   "
            "   W 0                    1 W   "
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

        1:
            Class: Character
            options:
                reflexive: true


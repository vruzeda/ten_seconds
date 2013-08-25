define [
    "resources/Constants"
    "models/objects/Character"
], (Constants, Character) ->

    MESSAGE: [
        "Hmm... Well..."
        "Something went wrong in your last experiment..."
        "Now, you are split in 2 bodies..."
        "(And here I am, just wishing I had one...)"
        ""
        "Well, you have to gather your other self,"
        "and you better do it in less than 10 seconds..."
        "Nasty things can happen if you don't,"
        "like crazy time warp things!"
    ]
    MESSAGE_OPTIONS:
        y: 100

    NEXT_LEVEL: "level.7"

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

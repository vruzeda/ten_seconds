define [
    "resources/Constants"
    "models/objects/Portal"
], (Constants, Portal) ->

    MESSAGE: [
        "AT LAST!"
        ""
        "If you still don't remember, that over there is"
        "your cloning machine... your under-development"
        "cloning machine, the Green Thumb."
        ""
        "And yes, you are going to clone yourself."
        "That was your great idea for a test, anyway..."
    ]
    MESSAGE_OPTIONS:
        y: 100

    NEXT_LEVEL: "level.6"

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
            "   W C                    0 W   "
            "   W                        W   "
            "   WWWWWWWWWWWWWWWWWWWWWWWWWW   "
            "                                "
            "                                "
            "                                "
        ]

    SPECIAL:
        0:
            Class: Portal
            options:
                fill: "#00FF00"

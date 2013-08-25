define [
    "resources/Constants"
    "models/objects/Portal"
], (Constants, Portal) ->

    MESSAGE: [
        "AT LAST!"
        ""
        "If you still don't remember, that over there is"
        "your new Portal... your under-development"
        "Time Traveling Portal, the Green Hole."
        ""
        "And yes, you are going to test it yourself."
        "As you said, it was your idea..."
        "(Great argument...)"
    ]
    MESSAGE_OPTIONS:
        y: 100

    NEXT_LEVEL: "level.intro.bodysplit"

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

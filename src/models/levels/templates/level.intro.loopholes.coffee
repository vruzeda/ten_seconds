define [
    "resources/Constants"
    "models/objects/Portal"
], (Constants, Portal) ->

    MESSAGE: [
        "There are also some loopholes..."
        "That was your idea, remember?"
        "(Great idea... :eyeroll:)"
    ]
    MESSAGE_OPTIONS:
        y: 100

    NEXT_LEVEL: "level.intro.greenhole"

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
            "   TTTTTTTTTTTTTTTTTTTTTTTTTT   "
            "   T                        T   "
            "   T 0                    P T   "
            "   T                        T   "
            "   T                        T   "
            "   T                        T   "
            "   T                        T   "
            "   T                        T   "
            "   T C                    0 T   "
            "   T                        T   "
            "   TTTTTTTTTTTTTTTTTTTTTTTTTT   "
            "                                "
            "                                "
            "                                "
        ]

    SPECIAL:
        0:
            Class: Portal
            options:
                targetLevel: "level.intro.loopholes"

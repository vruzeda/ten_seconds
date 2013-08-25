define [
    "resources/Constants"
    "models/objects/Portal"
], (Constants, Portal) ->

    NEXT_LEVEL: "level.bodysplit.3"

    MAP:
        [
            "                                "
            "                                "
            "   TTTTTTT        WWWWWWWWWWW   "
            "   W     W        W         W   "
            "   W     W        W 0     C W   "
            "   W     W        W         W   "
            "   T   TTT        WWWWWWWWWWW   "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   T                        "
            "   T   TTT        WWWWWWWWWWW   "
            "   T     T        W         W   "
            "   T C   T        W C       W   "
            "   T     T        W         W   "
            "   TTTTTTT        WWWWWWWWWWW   "
            "                                "
            "                                "
            "                                "
        ]

    SPECIAL:
        0:
            Class: Portal
            options:
                fill: "#00FF00"

define [
    "resources/Constants"
    "models/objects/Portal"
], (Constants, Portal) ->

    NEXT_LEVEL: "level.bodysplit.4"

    MAP:
        [
            "                                "
            "                                "
            "   TTTTTTT        WWWWWWWWWWW   "
            "   W     WWWWWWWWWW         W   "
            "   W C                    C W   "
            "   W     WWWWWWWWWW         W   "
            "   T   TTT        WWWWWW   WW   "
            "   T   T               W   W    "
            "   T   T               W   W    "
            "   T   T               W   W    "
            "   T   T               W   W    "
            "   T   T               W 0 W    "
            "   T   T               W   W    "
            "   T   T               W   W    "
            "   T   T               W   W    "
            "   T   T               W   W    "
            "   T   TTT        WWWWWW   WW   "
            "   T     WWWWWWWWWW         W   "
            "   T C              C       W   "
            "   T     WWWWWWWWWW         W   "
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

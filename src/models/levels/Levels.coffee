define [
    "utils/CountdownLatch"
], (CountdownLatch) ->

    class Levels

        @loadLevels: (callback) ->
            @_levels = {}

            levelList = [
                "level.intro.walking"
                "level.intro.running"
                "level.intro.traps"
                "level.intro.loopholes"
                "level.intro.greenhole"
                "level.intro.bodysplit"
                "level.bodysplit.1"
                "level.bodysplit.2"
                "level.bodysplit.3"
                "level.bodysplit.4"
                "level.8"
                "level.game.over"
            ]

            levelsLatch = new CountdownLatch levelList.length,
                success: callback

            for level in levelList
                do (level) =>
                    require ["models/levels/templates/#{level}"], (Level) =>
                        @_levels[level] = Level
                        levelsLatch.step()

        @getLevel: (level) ->
            @_levels[level]

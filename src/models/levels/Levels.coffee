define [
    "utils/CountdownLatch"
], (CountdownLatch) ->

    class Levels

        @loadLevels: (callback) ->
            @_levels = {}

            levelList = [
                "level.1"
                "level.2"
                "level.3"
                "level.4"
                "level.5"
                "level.6"
                "level.7"
                "level.8"
                "level.9"
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

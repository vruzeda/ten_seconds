require.config
    urlArgs: "bust=#{Date.now()}"

    paths:
        Kinetic: "lib/kinetic-v4.6.0.min"

require [
    "TenSeconds"
], (TenSeconds) ->

    new TenSeconds()

require.config
	urlArgs: "bust=#{Date.now()}"

	paths:
		jQuery:  "lib/jquery-2.0.3.min"
		Kinetic: "lib/kinetic-v4.6.0.min"

require [
	"TenSeconds"
], (TenSeconds) ->

	new TenSeconds()

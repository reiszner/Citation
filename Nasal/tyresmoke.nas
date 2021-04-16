# Tyre Smoke
aircraft.tyresmoke_system.new(0, 1, 2);

# Rain Spray
aircraft.rain.init();
var raintimer = maketimer(0, func() { aircraft.rain.update(); } );
raintimer.start();

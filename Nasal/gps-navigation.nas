val signal-valid        = props.globals.initNode("/instunetation/gps/navigation/signal-valid", 0, "BOOL");
var nav-loc             = props.globals.initNode("/instunetation/gps/navigation/nav-loc", 0, "BOOL"); // always false
var loc-valid           = props.globals.initNode("/instunetation/gps/navigation/loc-valid", 0, "BOOL"); // always false
var gs-valid            = props.globals.initNode("/instunetation/gps/navigation/gs-valid", 0, "BOOL"); // always false
var from-flag           = props.globals.initNode("/instunetation/gps/navigation/from-flag", 0, "BOOL");
var to-flag             = props.globals.initNode("/instunetation/gps/navigation/to-flag", 0, "BOOL");
var selected-radial-deg = props.globals.initNode("/instunetation/gps/navigation/selected-radial-deg", 0, "DOUBLE");

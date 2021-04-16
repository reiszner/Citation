aircraft.livery.init("Models/Liveries");
var cabin_door = aircraft.door.new("controls/cabin-door", 2);
var baggage_door_front_left = aircraft.door.new("controls/baggage-door-front-left",2);
var baggage_door_front_right = aircraft.door.new("controls/baggage-door-front-right",2);
var baggage_door_aft = aircraft.door.new("controls/baggage-door-aft",2);
var SndIn = props.globals.getNode("/sim/sound/Cvolume",1);
var SndOut = props.globals.getNode("/sim/sound/Ovolume",1);

#Jet Engine Helper class
# ie: var Eng = JetEngine.new(engine number);

# The jet engines in YASim are always on and cannot be turned off except by
# fuel starvation.  We want to be able to turn our engines on (spool up) and
# off at will, so our flightdeck does not display /engines/engine[*]/n1 and n2
# from YASim, instead they show /engines/engine[*]/fan and turbine,
# respectively.  Both fan and turbine start at zero and will spool up to reach
# n1 and n2; at that point we declare the engine to be running.

var JetEngine = {
    new : func(eng_num) {
        m = { parents : [JetEngine]};

        m.eng = props.globals.getNode("engines/engine["~eng_num~"]",1);
# NOT the running property from YASim, which is always true and therefore useless.
        m.running =  m.eng.initNode("started",0,"BOOL");
        m.itt =      m.eng.getNode("itt-norm");
        m.n1 =       m.eng.getNode("n1",1);
        m.n2 =       m.eng.getNode("n2",1);
        m.fan =      m.eng.initNode("fan",0,"DOUBLE");
        m.turbine =  m.eng.initNode("turbine",0,"DOUBLE");
        m.fuel_out = m.eng.initNode("out-of-fuel",0,"BOOL");
        m.oil_psi  = m.eng.initNode("oil-pressure-psi",0,"DOUBLE");
        m.hyd_fire = props.globals.getNode("systems/hydraulic/valves/firewall-shutoff["~eng_num~"]/state",1,"BOOL");
        m.hyd_service = props.globals.getNode("systems/hydraulic/supplier/pump["~eng_num~"]/serviceable",1,"BOOL");
        m.hyd_psi  = props.globals.getNode("systems/hydraulic/supplier/pump["~eng_num~"]/pressure-psi",0,"DOUBLE");
        m.hyd_gpm  = props.globals.getNode("systems/hydraulic/supplier/pump["~eng_num~"]/quantity-gpm",0,"DOUBLE");

        m.ctrl = props.globals.getNode("controls/engines/engine["~eng_num~"]",1);
        m.throttle =       m.ctrl.initNode("throttle",0,"DOUBLE");
        m.throttle_real =  m.ctrl.initNode("throttle-real",0,"DOUBLE");
        m.throttle_lever = m.ctrl.initNode("throttle-lever",0,"DOUBLE");
        m.reverser =       m.ctrl.initNode("reverser",0,"BOOL");
        m.reverser_lever = m.ctrl.initNode("reverser-lever",0,"DOUBLE");
        m.cutoff =         m.ctrl.initNode("cutoff",0,"BOOL");
        m.cutoff_lock =    m.ctrl.initNode("cutoff-lock",0,"BOOL");

        m.reverser_pos =      props.globals.initNode("surface-positions/reverser-norm["~eng_num~"]",0,"DOUBLE");
        m.generator_sw =      props.globals.initNode("controls/electric/engine["~eng_num~"]/generator-sw",0,"BOOL");
        m.starter =           props.globals.initNode("controls/electric/engine["~eng_num~"]/starter",0,"BOOL");
        m.starter_btn =       props.globals.initNode("controls/electric/engine["~eng_num~"]/starter-btn",0,"BOOL");
        m.boost_pump =        props.globals.initNode("controls/fuel/tank["~eng_num~"]/boost-pump",0,"BOOL");

        m.Lfuel = setlistener(m.fuel_out, func m.shutdown(m.fuel_out.getValue()),0,0);
#        m.Cut = setlistener(m.cutoff, func m.shutdown(m.cutoff.getValue()),0,0);

        m.autostart_in_progress = 0;
        m.cutoff_arm = 0;
        m.timer = 0;
        m.hobbs_timer = aircraft.timer.new ("engines/engine["~eng_num~"]/running-time-s");
        return m;
    },



#### update ####
    update : func{

        if (me.running.getBoolValue() and getprop("systems/electrical/outputs/main-right-xover/inst-flt-hr")) {
            if (!me.timer) {
                me.hobbs_timer.start ();
                me.timer = 1;
            }
        } else {
            if (me.timer) {
                me.hobbs_timer.stop ();
                me.timer = 0;
            }
        }

        var thr = me.throttle.getValue();
        var real = me.throttle_real.getValue();
        var lever = me.throttle_lever.getValue();

# cut-off position
        if (lever < 0.0) {
            lever += (thr - 0.01);
            if (lever < -0.2) lever = -0.2;
            real = 0.0;
        }

        if (lever > -0.2 and lever < 0.0) {
            if (me.cutoff_lock.getBoolValue()) {
                if (lever < -0.1) lever = -0.2;
                else lever = 0.0;
            }
            else {
                me.cutoff_arm = 1;
            }
        }

        if (me.cutoff_arm) {
            if (lever > -0.005 or lever < -0.195) {
                me.cutoff_lock.setBoolValue(1);
                me.cutoff_arm = 0;
            }
        }
        else {
             if (me.cutoff.getBoolValue()) {
                if (lever > -0.195) { lever = -0.2; thr = 0.0; }
            }
            else {
                if (lever < -0.005) { lever = 0.0; }
            }
        }

        if (lever > -0.1) {
            me.cutoff.setBoolValue(0);
        }
        else {
            me.cutoff.setBoolValue(1);
        }

        if (lever >= 0.0) {
# if reverser moving
            if (me.reverser_pos.getValue() != nil and
                me.reverser_pos.getValue() > 0.0 and
                me.reverser_pos.getValue() < 1.0
            )
            {
                thr = 0.0;
                lever = 0.0;
                real = 0.0;
            }

# reverser deployed
            if (me.reverser.getBoolValue()) {
                lever = 0.0;
                if (me.running.getBoolValue()) {
                    real = thr * 0.92;
                } else {
                    real = 0.0;
                }
                me.reverser_lever.setValue(thr * 0.92 + 0.08);
            }
# reverser stowed
            else {
                if (!me.cutoff_lock.getBoolValue() and thr < 0.005) {
                    lever = -0.01;
                    thr = 0.0;
                    real = 0.0;
                }
                else {
                    lever = thr;
                    if (me.running.getBoolValue()) {
                        real = thr;
                    } else {
                        real = 0.0;
                    }
                }
                me.reverser_lever.setValue(0.0);
            }
        }

        me.throttle.setValue(thr);
        me.throttle_real.setValue(real);
        me.throttle_lever.setValue(lever);

# if the engine is running
        if(me.running.getBoolValue ()) {
            if(getprop("controls/engines/grnd_idle")) thr *= 0.92;

# autostart successfull
            if (me.autostart_in_progress) {
                me.generator_sw.setValue (1);
                me.throttle.setValue (0.0);
                me.autostart_in_progress = 0;
            }

# if the engine is NOT running
        } else {
# if autostart is in progress ...
            if (me.autostart_in_progress and me.cutoff.getBoolValue()) {
# ... push the starter button
                if (me.turbine.getValue() < 9) {
                    me.starter_btn.setValue (getprop("sim/time/elapsed-sec"));
                }
# ... push the throttle to idle
                else {
                    me.throttle.setValue (0.02);
                }
            }
        }

#        me.fuel_pph.setValue(me.fuel_gph.getValue() * me.fdensity.getValue());

# fluid pump factor
        var factor = 1.0 - (me.turbine.getValue() * 0.01);
        var x = 1.0 - (factor * factor * factor * factor);

# oil pump
        me.oil_psi.setValue(x * 85.0);
# hydraulic pump
        if(me.hyd_service.getValue() & !me.hyd_fire.getValue() ) {
            me.hyd_psi.setValue(x * 60.0);
            me.hyd_gpm.setValue(me.turbine.getValue() * 0.03);
        } else {
            me.hyd_psi.setValue(0.0);
            me.hyd_gpm.setValue(0.0);
        }
    },

    shutdown : func(b) {
    },

    autostart : func {
        me.autostart_in_progress = 1;
        me.cutoff_lock.setBoolValue (0);
    }
};



#################################################
var LHeng = JetEngine.new(0);
var RHeng = JetEngine.new(1);

var resetTrim = func(){
  setprop("/controls/flight/elevator-trim", 0);
  setprop("/controls/flight/rudder-trim", 0);
  setprop("/controls/flight/aileron-trim", 0);
  #print("All trim settings reset to 0...");
}

var resetControls = func() {
  setprop("/controls/flight/elevator", 0);
  setprop("/controls/flight/rudder", 0);
  setprop("/controls/flight/aileron", 0);
  #print("All flight controls reset to 0...");
}




setlistener("/sim/signals/fdm-initialized", func {

  if (getprop("/consumables/fuel/fuel_overlay") == 1) {
    # if we initialising a state overlay, then use pre-programmed fuel levels
    var fuelL= getprop("/consumables/fuel/fuel_overlay_0");
    var fuelR= getprop("/consumables/fuel/fuel_overlay_1");
    print("Setting fuel levels to ", fuelL, "lbs in left tank and ", fuelR, "lbs in right tank.");

    # set some other properties
    if(getprop("/gear/gear_overlay") == 1) {
      print("forcing gear down!");
      setprop("/controls/gear/gear-lever-cmd", 1);
      setprop("/controls/gear/gear-lever-pos", 1);
      setprop("/controls/gear/gear-down", 1);
    }
  }
  else {
    # Read old fuel levels
    var fuelL= getprop("/consumables/fuel/fuel-gal_us-0");
    var fuelR= getprop("/consumables/fuel/fuel-gal_us-1");
      # make sure we don't pass along a nil! (Most likely because this is our
      # first run with this model and have no previous value stored.)
    if(fuelL == nil or fuelR == nil) {
      fuelL = 371;
      fuelR = 371;
      print("No stored fuel-levels found. Setting to full.");
    }
    else {
      print("Old fuel-levels restored. You have ", fuelL, "lbs in left tank and ", fuelR, "lbs in right tank aboard.");
    }
  }
  # Override default "full tanks" with read values
  setprop("/consumables/fuel/tank[0]/level-gal_us", fuelL);
  setprop("/consumables/fuel/tank[1]/level-gal_us", fuelR);

  var batt_save = getprop("/systems/electrical/supplier/battery/percent-save");
  if(batt_save == nil) {
    batt_save = 1.0;
    print("Brand new battery installed.");
  }
  else {
    print("Battery restored. There are ", (batt_save * 100.0), "% charge left.");
  }
  setprop("/systems/electrical/supplier/battery/percent", batt_save);

  # on state overlays "taxi", "take-off" and "approach" we set the pressure automatically
  # since every checklist would agree to do this ahead of time!
  if (getprop("/environment/overlay") == 1) {
    var setAltimeterToPressure = maketimer(2, func() {
      setprop("/instrumentation/altimeter[0]/setting-inhg", getprop("/environment/metar[0]/pressure-sea-level-inhg"));
      print("Altimeter 1 set to ", getprop("/environment/metar[0]/pressure-sea-level-inhg"));
      setprop("/instrumentation/altimeter[1]/setting-inhg", getprop("/environment/metar[0]/pressure-sea-level-inhg"));
      print("Altimeter 2 set to ", getprop("/environment/metar[0]/pressure-sea-level-inhg"));
      setAltimeterToPressure.stop();
    });
    setAltimeterToPressure.singleShot = 1;
    setAltimeterToPressure.start();
  }

  # on states "cruise" and "approach" we set a heading from the launcher/CLI (--heading=123)
  if (getprop("/autopilot/heading_overlay")) {

    # start autopilot late, to avoid turbulent reactions from it
    var start_autopilot_in_air = maketimer(3, func(){
      print("Starting A/P ...");

      var overlay_name = getprop("/autopilot/overlay-name");
      if (overlay_name != nil) {
        if (overlay_name == "cruise") {
          var low_bank = 1;
          var yaw_damper = 1;
          var soft_ride = 1;
          var lateral_mode = 1;
          var vertical_mode = 1;
          var target_altitude = 36000;
        }
        if (overlay_name == "approach") {
          var low_bank = 0;
          var yaw_damper = 0;
          var soft_ride = 0;
          var lateral_mode = 0;
          var vertical_mode = 0;
          var target_altitude = 3000;
        }

# engage FD and AP
        setprop("/autopilot/ms-205[0]/mode/state", 1);
        setprop("/autopilot/mode/engaged", 1);
        print ("FD1 and AP engaged because /autopilot/heading-overlay is nonzero");
# setting autopilot
        setprop("/autopilot/mode/low-bank", low_bank);
        setprop("/autopilot/mode/yaw-damper", yaw_damper);
        setprop("/autopilot/mode/soft-ride", soft_ride);
# setting flight director
        setprop("/autopilot/ms-205[0]/mode/lateral-mode", lateral_mode);
        setprop("/autopilot/ms-205[0]/mode/vertical-mode", vertical_mode);
        setprop("/autopilot/ms-205[1]/mode/lateral-mode", lateral_mode);
        setprop("/autopilot/ms-205[1]/mode/vertical-mode", vertical_mode);
# setting heading
        var true_heading = getprop("/sim/presets/heading-deg");
        var magnetic_offset = getprop("/environment/magnetic-variation-deg");
        var magnetic_heading = true_heading + magnetic_offset;
        setprop("/autopilot/source/heading-bug-deg", magnetic_heading);
        print("HeadingOverlay requested... heading-bug set to ", magnetic_heading, "°");
      }

      start_autopilot_in_air.stop();
    });
    start_autopilot_in_air.singleShot = 1;
    start_autopilot_in_air.start();
  }

  # override saved aircraft-data. It stores some useless data, and ignores some useful data.
  saveState.update_saveState();


#  resetTrim();
#  resetControls();
#
#  var resetFlightControls = maketimer(0.5, func() {
#    resetTrim();
#    resetControls();
#    resetFlightControls.stop();
#  });
#  resetFlightControls.singleShot = 1;
#  resetFlightControls.start();




  SndIn.setDoubleValue(0.75);
  SndOut.setDoubleValue(0.15);
  settimer(update_systems,2);
# Initially drive the pilot's HSI with NAV1 and copilot's with NAV2
#  drive_hsi_with_nav (props.globals.getNode ("/instrumentation/hsi[0]"),
#                      props.globals.getNode ("/instrumentation/nav[0]"));
#  drive_hsi_with_nav (props.globals.getNode ("/instrumentation/hsi[1]"),
#                      props.globals.getNode ("/instrumentation/nav[1]"));
});

setlistener("/sim/current-view/internal", func(vw){
    if(vw.getBoolValue()){
        SndIn.setDoubleValue(0.75);
        SndOut.setDoubleValue(0.10);
    }else{
        SndIn.setDoubleValue(0.10);
        SndOut.setDoubleValue(0.75);
    }
},1,0);

setlistener("sim/model/autostart", func(strt) {
    if(strt.getBoolValue()){
        Startup();
    }else{
        Shutdown();
    }
},0,0);

var Startup = func{
    setprop("controls/electric/avionics-switch",1);
    setprop("controls/electric/battery-bus-switch",1);
    setprop("controls/electric/inverter-switch",1);
    setprop("controls/lighting/panel-lights-switch",1);
    setprop("controls/lighting/nav-lights-switch",1);
    setprop("controls/lighting/beacon-switch",1);
    setprop("controls/lighting/strobe-switch",1);
    setprop("controls/engines/throttle_idle",1);
    LHeng.autostart();
    RHeng.autostart();
}

var Shutdown = func{
    setprop("controls/electric/avionics-switch",0);
    setprop("controls/electric/battery-bus-switch",0);
    setprop("controls/lighting/panel-lights-switch",1);
    setprop("controls/lighting/nav-lights-switch",0);
    setprop("controls/lighting/beacon-switch",0);
    setprop("controls/lighting/strobe-switch",0);
    setprop("controls/engines/engine[0]/throttle",0);
    setprop("controls/engines/engine[1]/throttle",0);
}

controls.gearDown = func(v) {
    if ( !getprop("/controls/electric/maingear-switch") and !getprop("/controls/gear/emer-gear-cmd")) {
        if (v < 0) {
            setprop("/controls/gear/gear-lever-cmd", 0);
        }
        elsif (v > 0) {
            setprop("/controls/gear/gear-lever-cmd", 1);
        }
    }
}

controls.flapsDown = func(v) {
    if (getprop("controls/flaps-stepped")) {
        var flap = getprop("controls/flight/flaps");
        if (v > 0) {
            if      (flap < 0.125) setprop("controls/flight/flaps", 0.125);
            else if (flap < 0.250) setprop("controls/flight/flaps", 0.250);
            else if (flap < 0.375) setprop("controls/flight/flaps", 0.375);
            else if (flap < 0.500) setprop("controls/flight/flaps", 0.500);
            else if (flap < 0.625) setprop("controls/flight/flaps", 0.625);
            else if (flap < 0.750) setprop("controls/flight/flaps", 0.750);
            else if (flap < 0.875) setprop("controls/flight/flaps", 0.875);
            else                   setprop("controls/flight/flaps", 1.000);

        }
        if (v < 0) {
            if      (flap > 0.875) setprop("controls/flight/flaps", 0.875);
            else if (flap > 0.750) setprop("controls/flight/flaps", 0.750);
            else if (flap > 0.625) setprop("controls/flight/flaps", 0.625);
            else if (flap > 0.500) setprop("controls/flight/flaps", 0.500);
            else if (flap > 0.375) setprop("controls/flight/flaps", 0.375);
            else if (flap > 0.250) setprop("controls/flight/flaps", 0.250);
            else if (flap > 0.125) setprop("controls/flight/flaps", 0.125);
            else                   setprop("controls/flight/flaps", 0.000);
        }
    } else {
        setprop("controls/flight/flaps-cmd",v);
    }
}

var switch_rmi = func(needle, nav_number) {
  var selected_input = getprop ("/instrumentation/rmi/" ~ needle ~ "/selected-input");
  var dest_node = props.globals.getNode ("/instrumentation/rmi/" ~ needle ~ "/in-range", 1);
  dest_node.unalias ();
  if (selected_input == "ADF") {
    #print("RMI[", nav_number, "]: selected_input == ADF (", selected_input, ")");
    var source_node = props.globals.getNode ("/instrumentation/adf/in-range");
    dest_node.alias (source_node);
  }
  elsif (selected_input == "VOR") {
    #print("RMI[", nav_number, "]: selected_input == VOR (", selected_input, ")");
    var source_node = props.globals.getNode ("/instrumentation/nav[" ~ nav_number ~ "]/in-range");
    dest_node.alias (source_node);
  }
}

var hobbs_meter = {
    d0: props.globals.initNode ("instrumentation/hobbs-meter/digits0", 1, "INT"),
    d1: props.globals.initNode ("instrumentation/hobbs-meter/digits1", 1, "INT"),
    d2: props.globals.initNode ("instrumentation/hobbs-meter/digits2", 1, "INT"),
    d3: props.globals.initNode ("instrumentation/hobbs-meter/digits3", 1, "INT"),
    d4: props.globals.initNode ("instrumentation/hobbs-meter/digits4", 1, "INT"),
    e0: props.globals.initNode ("engines/engine[0]/running-time-s", 1, "DOUBLE"),
    e1: props.globals.initNode ("engines/engine[1]/running-time-s", 1, "DOUBLE"),
    update: func () {
        var left =  me.e0.getValue() or 0.0;
        var right = me.e1.getValue() or 0.0;
        var h = (left > right ? left : right) / 360.0; # tenths of hour, initially
        me.d0.setValue (math.mod (int (h), 10)); h = h / 10;
        me.d1.setValue (math.mod (int (h), 10)); h = h / 10;
        me.d2.setValue (math.mod (int (h), 10)); h = h / 10;
        me.d3.setValue (math.mod (int (h), 10)); h = h / 10;
        me.d4.setValue (math.mod (int (h), 10)); h = h / 10;
    },
};

var update_systems = func() {
    LHeng.update();
    RHeng.update();
    if(getprop("velocities/groundspeed-kt")>10) {
        cabin_door.close();
        baggage_door_aft.close();
        baggage_door_front_left.close();
        baggage_door_front_right.close();
    }

    # ugly hack! See Citation-II-common.xml line 711
    setprop("/consumables/fuel/fuel-gal_us-0", getprop("consumables/fuel/tank[0]/level-gal_us"));
    setprop("/consumables/fuel/fuel-gal_us-1", getprop("consumables/fuel/tank[1]/level-gal_us"));
    setprop("/systems/electrical/supplier/battery/percent-save", getprop("/systems/electrical/supplier/battery/percent"));

    hobbs_meter.update ();

    settimer(update_systems,0);
}

### own Fuel and Payload dialog
gui.menuBind("fuel-and-payload", "gui.showDialog('Citation-II-fuel_and_payload')");

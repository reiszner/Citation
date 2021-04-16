### calculation of towbar, tug and axis for realistic pushback

var pushback = {
  new : func() {
    m = { parents : [pushback] };
    m.pb = props.globals.getNode("sim/model/pushback",1);

    m.nose_angle      = props.globals.getNode("gear/gear[0]/caster-angle-deg-filtered",0,"DOUBLE");
    m.velocity        = props.globals.getNode("velocities/uBody-fps",0,"DOUBLE");
#    m.velocity        = props.globals.getNode("gear/gear[0]/rollspeed-ms-filtered",0,"DOUBLE");
    m.timelaps        = props.globals.getNode("sim/time/delta-realtime-sec",0,"DOUBLE");
    m.linked          = m.pb.getNode("linked",0,"BOOL");
    m.enabled         = m.pb.getNode("enabled",0,"BOOL");
    m.mlg_distance    = m.pb.getNode("geometry/distance-mlg",0,"DOUBLE");
    m.hitch_distance  = m.pb.getNode("geometry/hitch/distance",0,"DOUBLE");
    m.axis0_distance  = m.pb.getNode("geometry/tug/axis[0]/distance",0,"DOUBLE");
    m.axis0_circum    = m.pb.getNode("geometry/tug/axis[0]/circumference",0,"BOOL");
    m.axis0_steerable = m.pb.getNode("geometry/tug/axis[0]/steerable",0,"BOOL");
    m.axis1_distance  = m.pb.getNode("geometry/tug/axis[1]/distance",0,"DOUBLE");
    m.axis1_circum    = m.pb.getNode("geometry/tug/axis[1]/circumference",0,"BOOL");
    m.axis1_steerable = m.pb.getNode("geometry/tug/axis[1]/steerable",0,"BOOL");

    m.visible     = m.pb.initNode("visible",0,"BOOL");
    m.turn_x      = m.pb.initNode("geometry/turning-center/x",0,"DOUBLE");
    m.turn_y      = m.pb.initNode("geometry/turning-center/y",0,"DOUBLE");
    m.hitch_y     = m.pb.initNode("geometry/hitch/y",0,"DOUBLE");
    m.hitch_x     = m.pb.initNode("geometry/hitch/x",0,"DOUBLE");
    m.hitch_y     = m.pb.initNode("geometry/hitch/y",0,"DOUBLE");
    m.hitch_angle = m.pb.initNode("geometry/hitch/angle",0,"DOUBLE");
    m.hitch_l     = m.pb.initNode("geometry/hitch/l",0,"DOUBLE");
    m.tug_fixing  = m.pb.initNode("geometry/tug/fixing",0,"DOUBLE");
    m.tug_angle   = m.pb.initNode("geometry/tug/angle",0,"DOUBLE");
    m.tug_x       = m.pb.initNode("geometry/tug/x",0,"DOUBLE");
    m.tug_y       = m.pb.initNode("geometry/tug/y",0,"DOUBLE");
    m.tug_l       = m.pb.initNode("geometry/tug/l",0,"DOUBLE");
    m.axis0_x     = m.pb.initNode("geometry/tug/axis[0]/x",0,"DOUBLE");
    m.axis0_y     = m.pb.initNode("geometry/tug/axis[0]/y",0,"DOUBLE");
    m.axis0_l     = m.pb.initNode("geometry/tug/axis[0]/l",0,"DOUBLE");
    m.axis0_angle = m.pb.initNode("geometry/tug/axis[0]/angle",0,"DOUBLE");
    m.axis0_spin  = m.pb.initNode("geometry/tug/axis[0]/spin",0,"DOUBLE");
    m.axis1_x     = m.pb.initNode("geometry/tug/axis[1]/x",0,"DOUBLE");
    m.axis1_y     = m.pb.initNode("geometry/tug/axis[1]/y",0,"DOUBLE");
    m.axis1_l     = m.pb.initNode("geometry/tug/axis[1]/l",0,"DOUBLE");
    m.axis1_angle = m.pb.initNode("geometry/tug/axis[1]/angle",0,"DOUBLE");
    m.axis1_spin  = m.pb.initNode("geometry/tug/axis[1]/spin",0,"DOUBLE");

    var fixing = 0.0;


    if (m.axis0_steerable.getBoolValue() and !m.axis1_steerable.getBoolValue()) {
      printf("axis 0 is steerable");
      fixing = m.axis1_distance.getValue();
    }
    else if (!m.axis0_steerable.getBoolValue() and m.axis1_steerable.getBoolValue()) {
      printf("axis 1 is steerable");
      fixing = m.axis0_distance.getValue();
    }
    else if (m.axis0_steerable.getBoolValue() and m.axis1_steerable.getBoolValue()) {
      printf("both axis are steerable");
      if (m.axis0_distance.getValue() > m.axis1_distance.getValue()) {
        fixing = ((m.axis0_distance.getValue() - m.axis1_distance.getValue()) / 2.0) + m.axis1_distance.getValue();
      } else {
        fixing = ((m.axis1_distance.getValue() - m.axis0_distance.getValue()) / 2.0) + m.axis0_distance.getValue();
      }
    }
    else {
      printf("no steerable axis!!!");
      fixing = 0.0;
    }

    m.tug_fixing.setValue(fixing);

    return m;
  },

  update : func{
    if (
      me.enabled.getBoolValue() and
      getprop("controls/electric/maingear-switch") and
      (getprop("sim/model/pushback/position-norm") > 0.3 or
      (me.velocity.getValue() < 10.0 and me.velocity.getValue() > -10.0))
    ) {
      me.visible.setBoolValue(1);
    } else {
      me.visible.setBoolValue(0);
    }

    if (me.visible.getBoolValue()) {
      if (getprop("engines/engine[0]/started")) {
        setprop("controls/engines/engine[0]/throttle", 0.0);
      }
      if (getprop("engines/engine[1]/started")) {
        setprop("controls/engines/engine[1]/throttle", 0.0);
      }

      if (me.linked.getBoolValue()) {
        setprop("controls/gear/brake-parking", 0.0);

        var nose_angle = me.nose_angle.getValue() * math.pi / 180.0;

### turning center
        var turning_center_x = 0.0;
        var turning_center_y = 0.0;
        if (nose_angle != 0.0) {
          turning_center_x = me.mlg_distance.getValue();
          turning_center_y = (1 / math.tan(nose_angle)) * me.mlg_distance.getValue() * -1.0;
        }
        me.turn_x.setValue(turning_center_x);
        me.turn_y.setValue(turning_center_y);

### hitch location
        me.hitch_x.setValue(math.cos(nose_angle) * me.hitch_distance.getValue());
        me.hitch_y.setValue(math.sin(nose_angle) * me.hitch_distance.getValue());
        var tc2hitch_x = (turning_center_x - me.hitch_x.getValue()) * -1.0;
        var tc2hitch_y = (turning_center_y - me.hitch_y.getValue()) * -1.0;
        var tc2hitch_l = math.sqrt((tc2hitch_x * tc2hitch_x) + (tc2hitch_y * tc2hitch_y));
        me.hitch_l.setValue(tc2hitch_l);

### tug location and angle
        var tc2hitch_a = 0.0;
        var tc2tug_a = 0.0;
        var tug_x = 0.0;
        var tug_y = 0.0;
        var tc2tug_l = 0.0;
        var tc2tug_x = 0.0;
        var tc2tug_y = 0.0;
        var tc2tug_cos = 0.0;
        var tc2tug_sin = 0.0;

        if (nose_angle != 0.0) {
          tc2hitch_a = math.atan(tc2hitch_x / tc2hitch_y);

          tc2tug_a = math.asin(me.tug_fixing.getValue() / tc2hitch_l);
          if (tc2hitch_a < 0.0) { tc2tug_a *= -1.0; }
          tc2tug_a += tc2hitch_a;
          tc2tug_a *= -1.0;

          tc2tug_cos = math.cos(tc2tug_a);
          tc2tug_sin = math.sin(tc2tug_a);
          tug_x = tc2tug_cos * me.tug_fixing.getValue() + me.hitch_x.getValue();
          tug_y = tc2tug_sin * me.tug_fixing.getValue() + me.hitch_y.getValue();
          tc2tug_x = turning_center_x - tug_x;
          tc2tug_y = turning_center_y - tug_y;
          tc2tug_l = math.sqrt((tc2tug_x * tc2tug_x) + (tc2tug_y * tc2tug_y));;
        }

        me.hitch_angle.setValue(tc2hitch_a * 180.0 / math.pi);
        me.tug_angle.setValue(tc2tug_a * 180.0 / math.pi);
        me.tug_x.setValue(tug_x);
        me.tug_y.setValue(tug_y);
        me.tug_l.setValue(tc2tug_l);

### calculate axis
        var axis0_x = 0.0;
        var axis0_y = 0.0;
        var axis0_l = 0.0;
        var axis0_a = 0.0;
        var axis1_x = 0.0;
        var axis1_y = 0.0;
        var axis1_l = 0.0;
        var axis1_a = 0.0;
        var tc2axis_x = 0.0;
        var tc2axis_y = 0.0;

        if (nose_angle != 0.0) {
          if (me.axis0_steerable.getBoolValue()) {
            axis0_x = tc2tug_cos * (me.axis0_distance.getValue()) + me.hitch_x.getValue();
            axis0_y = tc2tug_sin * (me.axis0_distance.getValue()) + me.hitch_y.getValue();
            tc2axis_x = turning_center_x - axis0_x;
            tc2axis_y = turning_center_y - axis0_y;
            axis0_l = math.sqrt((tc2axis_x * tc2axis_x) + (tc2axis_y * tc2axis_y));
            axis0_a = math.asin((me.tug_fixing.getValue() - me.axis0_distance.getValue()) / tc2tug_l);
            if (tc2tug_a < 0.0) { axis0_a *= -1.0; }
            axis0_a += tc2tug_a;
          }
          if (me.axis1_steerable.getBoolValue()) {
            axis1_x = tc2tug_cos * (me.axis1_distance.getValue()) + me.hitch_x.getValue();
            axis1_y = tc2tug_sin * (me.axis1_distance.getValue()) + me.hitch_y.getValue();
            tc2axis_x = turning_center_x - axis1_x;
            tc2axis_y = turning_center_y - axis1_y;
            axis1_l = math.sqrt((tc2axis_x * tc2axis_x) + (tc2axis_y * tc2axis_y));
            axis1_a = math.asin((me.tug_fixing.getValue() - me.axis1_distance.getValue()) / tc2tug_l);
            if (tc2tug_a < 0.0) { axis1_a *= -1.0; }
            axis1_a += tc2tug_a;
          }
        }

        me.axis0_angle.setValue(axis0_a * 180.0 / math.pi);
        me.axis0_x.setValue(axis0_x);
        me.axis0_y.setValue(axis0_y);
        me.axis0_l.setValue(axis0_l);
        me.axis1_angle.setValue(axis1_a * 180.0 / math.pi);
        me.axis1_x.setValue(axis1_x);
        me.axis1_y.setValue(axis1_y);
        me.axis1_l.setValue(axis1_l);

        var speed = me.velocity.getValue() * 60.0 * 0.3048;
        me.axis0_spin.setValue(speed / me.axis0_circum.getValue());
        me.axis1_spin.setValue(speed / me.axis1_circum.getValue());

      }
      else {
        setprop("controls/gear/brake-parking", 1.0);

        me.hitch_angle.setValue(0.0);
        me.hitch_x.setValue(me.hitch_distance.getValue());
        me.hitch_y.setValue(0.0);
        me.tug_angle.setValue(0.0);
        me.axis0_angle.setValue(0.0);
        me.axis0_spin.setValue(0.0);
        me.axis1_angle.setValue(0.0);
        me.axis1_spin.setValue(0.0);
      }
    }
  }

};

var PB = pushback.new();

var update_pushback = func() {
  PB.update();
  settimer(update_pushback,0);
}

setlistener("/sim/signals/fdm-initialized",
  func {
    settimer(update_pushback,2);
  }
);


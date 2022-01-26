### calculation of towbar, tug and axis for realistic pushback

var pushback = {
    new : func() {
        m = { parents : [pushback] };
        m.pb = props.globals.getNode("sim/model/pushback",1);

        m.nose_angle        = props.globals.getNode("gear/gear[0]/caster-angle-deg-filtered",0,"DOUBLE");
        m.velocity          = props.globals.getNode("gear/gear[0]/rollspeed-ms-filtered",0,"DOUBLE");
        m.timelaps          = props.globals.getNode("sim/time/delta-realtime-sec",0,"DOUBLE");
        m.view_angle        = props.globals.getNode("orientation/pitch-deg",0,"DOUBLE");
        m.cur_view_number   = props.globals.getNode("sim/current-view/view-number-raw",0,"DOUBLE");
        m.cur_view_x        = props.globals.getNode("sim/current-view/z-offset-m",0,"DOUBLE");
        m.cur_view_y        = props.globals.getNode("sim/current-view/x-offset-m",0,"DOUBLE");
        m.cur_view_z        = props.globals.getNode("sim/current-view/y-offset-m",0,"DOUBLE");
        m.cur_view_pitch    = props.globals.getNode("sim/current-view/goal-pitch-offset-deg",0,"DOUBLE");
        m.cur_view_heading  = props.globals.getNode("sim/current-view/goal-heading-offset-deg",0,"DOUBLE");

        m.max_steering      = m.pb.getNode("max-steering",0,"DOUBLE");
        m.fdm_system        = m.pb.initNode("fdm-system",0,"INT");
        m.enabled           = m.pb.initNode("enabled",0,"BOOL");
        m.connect           = m.pb.initNode("connect",0,"BOOL");
        m.linked            = m.pb.initNode("linked",0,"BOOL");
        m.visible           = m.pb.initNode("visible",0,"DOUBLE");
        m.position          = m.pb.initNode("position-norm",0,"DOUBLE");
        m.steering          = m.pb.initNode("steering",0,"DOUBLE");
        m.steering_factor   = m.pb.initNode("steering-factor",0,"DOUBLE");

        m.mlg_distance      = m.pb.getNode("aircraft/mlg-distance",0,"DOUBLE");
        m.aircraft_steering = m.pb.initNode("aircraft/steering",0,"DOUBLE");
        m.aircraft_turn_x   = m.pb.initNode("aircraft/turn-center-x",0,"DOUBLE");
        m.aircraft_turn_y   = m.pb.initNode("aircraft/turn-center-y",0,"DOUBLE");
        m.aircraft_radius   = m.pb.initNode("aircraft/turn-radius",0,"DOUBLE");
        m.aircraft_circum   = m.pb.initNode("aircraft/turn-circum",0,"DOUBLE");
        m.aircraft_arc      = m.pb.initNode("aircraft/arc",0,"DOUBLE");
        m.aircraft_arc_deg  = m.pb.initNode("aircraft/arc-deg",0,"DOUBLE");
        m.aircraft_dist     = m.pb.initNode("aircraft/distance",0,"DOUBLE");

        m.hitch_distance    = m.pb.getNode("hitch/distance",0,"DOUBLE");

        m.axis0_distance    = m.pb.getNode("tug/axis[0]/distance",0,"DOUBLE");
        m.axis0_circum      = m.pb.getNode("tug/axis[0]/circumference",0,"BOOL");
        m.axis0_steerable   = m.pb.getNode("tug/axis[0]/steerable",0,"BOOL");
        m.axis1_distance    = m.pb.getNode("tug/axis[1]/distance",0,"DOUBLE");
        m.axis1_circum      = m.pb.getNode("tug/axis[1]/circumference",0,"BOOL");
        m.axis1_steerable   = m.pb.getNode("tug/axis[1]/steerable",0,"BOOL");

        m.tug_pos_x         = m.pb.initNode("tug/pos-x",0,"DOUBLE");
        m.tug_pos_y         = m.pb.initNode("tug/pos-y",0,"DOUBLE");
        m.tug_fixing        = m.pb.initNode("tug/fixing",0,"DOUBLE");
        m.tug_axel          = m.pb.initNode("tug/axel-spacing",0,"DOUBLE");
        m.tug_angle         = m.pb.initNode("tug/angle",0,"DOUBLE");
        m.tug_steering      = m.pb.initNode("tug/steering",0,"DOUBLE");

        m.axis0_angle       = m.pb.initNode("tug/axis[0]/angle",0,"DOUBLE");
        m.axis0_spin        = m.pb.initNode("tug/axis[0]/spin",0,"DOUBLE");
        m.axis1_angle       = m.pb.initNode("tug/axis[1]/angle",0,"DOUBLE");
        m.axis1_spin        = m.pb.initNode("tug/axis[1]/spin",0,"DOUBLE");

        m.view_number       = m.pb.getNode("view/number",0,"INT");
        m.view_init_x       = m.pb.getNode("view/init-x",0,"DOUBLE");
        m.view_init_y       = m.pb.getNode("view/init-y",0,"DOUBLE");
        m.view_init_z       = m.pb.getNode("view/init-z",0,"DOUBLE");
        m.view_tug_x        = m.pb.getNode("view/tug-x",0,"DOUBLE");
        m.view_tug_z        = m.pb.getNode("view/tug-z",0,"DOUBLE");
        m.view_look_to      = m.pb.getNode("view/look-to",0,"DOUBLE");

        if (getprop("/sim/flight-model") == "jsb") {
            m.fdm_system.setValue(1);
        }
        else if (getprop("/sim/flight-model") == "yasim") {
            m.fdm_system.setValue(2);

        }
        m.steering_factor.setValue(m.max_steering.getValue() * math.pi / 180.0);

        var tug_fixing = 0.0;
        var tug_axel = 0.0;
        if (m.axis0_steerable.getBoolValue() and !m.axis1_steerable.getBoolValue()) {
            printf("axis 0 is steerable");
            tug_fixing = m.axis1_distance.getValue();
            tug_axel = abs(tug_fixing - m.axis0_distance.getValue());
        }
        else if (!m.axis0_steerable.getBoolValue() and m.axis1_steerable.getBoolValue()) {
            printf("axis 1 is steerable");
            tug_fixing = m.axis0_distance.getValue();
            tug_axel = abs(tug_fixing - m.axis1_distance.getValue());
        }
        else if (m.axis0_steerable.getBoolValue() and m.axis1_steerable.getBoolValue()) {
            printf("both axis are steerable");
            tug_axel = abs(m.axis0_distance.getValue() - m.axis1_distance.getValue()) / 2.0;
            if (m.axis0_distance.getValue() < m.axis1_distance.getValue()) {
                tug_fixing = tug_axel + m.axis0_distance.getValue();

            } else {
                tug_fixing = tug_axel + m.axis1_distance.getValue();
            }
        }
        else {
            printf("no steerable axis!!!");
            tug_fixing = 0.0;
        }

        m.tug_fixing.setValue(tug_fixing);
        m.tug_axel.setValue(tug_axel);

        return m;
    },

    update : func{
        if (me.enabled.getBoolValue()) {
### make sure engines are idle
            if (getprop("engines/engine[0]/started")) {
                setprop("controls/engines/engine[0]/throttle", 0.0);
            }
            if (getprop("engines/engine[1]/started")) {
                setprop("controls/engines/engine[1]/throttle", 0.0);
            }
            if (!getprop("sim/view[107]/enabled")) {
                setprop("sim/view[107]/enabled", 1);
            }

### if we are connected release the parking brake
            if (me.linked.getBoolValue()) {
                setprop("controls/gear/brake-parking", 0.0);

### calculate how far we are rolled   m.timelaps
                var aircraft_dist = me.velocity.getValue() * me.timelaps.getValue();
                var aircraft_steering = me.aircraft_steering.getValue() * me.steering_factor.getValue();

### aircraft
                var aircraft_turn_center_x = me.mlg_distance.getValue();
                var aircraft_turn_center_y = 0.0;
                var aircraft_turn_radius = 0.0;
                var aircraft_turn_circum = 0.0;
                var aircraft_turn_arc = 0.0;

                setprop("sim/model/pushback/aircraft/steering-deg", aircraft_steering * 180.0 / math.pi);

                if (aircraft_steering != 0.0) {
                    aircraft_turn_center_y = (-1.0 / math.tan(aircraft_steering)) * aircraft_turn_center_x;
#                    aircraft_turn_radius = abs((1.0 / math.sin(aircraft_steering)) * aircraft_turn_center_x);
                    aircraft_turn_radius =    (1.0 / math.sin(aircraft_steering)) * aircraft_turn_center_x;
                    aircraft_turn_circum = 2.0 * math.pi * aircraft_turn_radius;
                    aircraft_turn_arc    = aircraft_dist / aircraft_turn_radius;
                }

                me.aircraft_turn_x.setValue(aircraft_turn_center_x);
                me.aircraft_turn_y.setValue(aircraft_turn_center_y);
                me.aircraft_radius.setValue(aircraft_turn_radius);
                me.aircraft_circum.setValue(aircraft_turn_circum);
                me.aircraft_dist.setValue(aircraft_dist);
                me.aircraft_arc.setValue(aircraft_turn_arc);
                me.aircraft_arc_deg.setValue(aircraft_turn_arc * 180.0 / math.pi);

### hitch
                var hitch_pos_x = math.cos(aircraft_steering) * me.hitch_distance.getValue();
                var hitch_pos_y = math.sin(aircraft_steering) * me.hitch_distance.getValue();
                var hitch_turn_x = hitch_pos_x - aircraft_turn_center_x;
                var hitch_turn_y = hitch_pos_y - aircraft_turn_center_y;
                var hitch_dist = math.sqrt((hitch_turn_x * hitch_turn_x) + (hitch_turn_y * hitch_turn_y));
                var point_angle = 0.0;
                var point_pos_x = 0.0;
                var point_pos_y = 0.0;

                if (aircraft_steering != 0.0) {
                    point_angle = math.atan(hitch_turn_y / hitch_turn_x) + aircraft_turn_arc;
                    point_pos_x = (math.cos(point_angle) * hitch_dist) + aircraft_turn_center_x;
                    point_pos_y = (math.sin(point_angle) * hitch_dist) + aircraft_turn_center_y;
                } else {
                    point_pos_x = hitch_pos_x - aircraft_dist;
                }

                setprop("sim/model/pushback/hitch/pos-x", hitch_pos_x);
                setprop("sim/model/pushback/hitch/pos-y", hitch_pos_y);
                setprop("sim/model/pushback/hitch/turn-x", hitch_turn_x);
                setprop("sim/model/pushback/hitch/turn-y", hitch_turn_y);
                setprop("sim/model/pushback/hitch/dist", hitch_dist);
                setprop("sim/model/pushback/hitch/point-a", point_angle);
                setprop("sim/model/pushback/hitch/point-deg", point_angle * 180.0 / math.pi);
                setprop("sim/model/pushback/hitch/point-x", point_pos_x);
                setprop("sim/model/pushback/hitch/point-y", point_pos_y);

### pushback tug
                var tug_angle = me.tug_angle.getValue() + aircraft_turn_arc;
                var tug_steering = me.tug_steering.getValue();
                var tug_fixing = me.tug_fixing.getValue();
                var tug_axel = me.tug_axel.getValue();
                var tug_axel0_speed = me.velocity.getValue();
                var tug_axel1_speed = me.velocity.getValue();

                var tug_turn_center_x = tug_fixing;
                var tug_turn_center_y = 0.0;
                var tug_turn_arc = 0.0;
                var tug_steering_radius = 0.0;
                var tug_steering_circum = 0.0;
                var tug_fixing_radius = 0.0;
                var tug_fixing_circum = 0.0;
                var tug_hitch_radius = 0.0;
                var tug_hitch_circum = 0.0;
                var tug_hitch_angle = 0.0;

                var tug_turn_x = 0.0;
                var tug_turn_y = 0.0;
                var tug_inter_dist = 0.0;
                var tug_inter_angle = 0.0;

                var intersect = {x: 0.0, y: 0.0};
                var tug_hitch_angle_new = 0.0;
                var angle_driven = 0.0;

                var target_tug_angle = 0.0;
                var target_tug_steering = 0.0;

                setprop("sim/model/pushback/tug/steering-deg", tug_steering * 180.0 / math.pi);


                if (tug_steering != 0.0) {
# local point positions
                    tug_turn_center_y = (1.0 / math.tan(tug_steering)) * tug_axel;
                    tug_steering_radius = abs((1.0 / math.sin(tug_steering)) * tug_axel);
                    tug_steering_circum = 2.0 * math.pi * tug_steering_radius;
                    tug_fixing_radius = abs(tug_turn_center_y);
                    tug_fixing_circum = 2.0 * math.pi * tug_fixing_radius;
                    tug_hitch_radius = math.sqrt((tug_turn_center_x * tug_turn_center_x) + (tug_turn_center_y * tug_turn_center_y));
                    tug_hitch_circum = 2.0 * math.pi * tug_hitch_radius;
                    tug_hitch_angle = angle_pt_pt(0.0, 0.0, tug_turn_center_x, tug_turn_center_y) + tug_angle;
# absolut position
                    tug_turn_x = point_pos_x + (tug_turn_center_x * math.cos(tug_angle)) - (tug_turn_center_y * math.sin(tug_angle));
                    tug_turn_y = point_pos_y + (tug_turn_center_x * math.sin(tug_angle)) + (tug_turn_center_y * math.cos(tug_angle));
                    tug_inter_dist = math.sqrt((tug_turn_x * tug_turn_x) + (tug_turn_y * tug_turn_y));
                    tug_inter_angle = angle_pt_pt(0.0, 0.0, tug_turn_x, tug_turn_y);
                    intersect = intersect_arc_arc(tug_inter_dist, tug_inter_angle, me.hitch_distance.getValue(), tug_hitch_radius, aircraft_steering);

                    tug_hitch_angle_new = angle_pt_pt(intersect.x, intersect.y, tug_turn_x, tug_turn_y);
                    tug_angle += tug_hitch_angle_new - tug_hitch_angle;
                    angle_driven = abs(tug_hitch_angle_new - tug_hitch_angle);
                    if (me.velocity.getValue() < 0.0) angle_driven *= -1.0;
                }
                else {
                    intersect = intersect_line_arc(point_pos_x, point_pos_y, tug_angle, me.hitch_distance.getValue());
                }


### new pos of tug
                aircraft_steering = angle_pt_pt(0.0, 0.0, intersect.x, intersect.y);
                hitch_pos_x = math.cos(aircraft_steering) * me.hitch_distance.getValue();
                hitch_pos_y = math.sin(aircraft_steering) * me.hitch_distance.getValue();

### target
                if (aircraft_steering != 0.0) {
                    target_tug_angle = math.asin(tug_fixing / hitch_dist) + math.atan(abs(hitch_turn_x) / abs(hitch_turn_y));
                    target_tug_steering = math.atan(tug_axel / math.sqrt((hitch_dist * hitch_dist) - (tug_fixing * tug_fixing)));
                    if (aircraft_steering < 0.0) {
                        target_tug_angle *= -1.0;
                        target_tug_steering *= -1.0;
                    }
                }
                var delta_angle = target_tug_angle - tug_angle;
                var delta_steering = target_tug_steering - tug_steering;
                var ac_delta_steering = me.steering.getValue() - aircraft_steering;


                me.tug_pos_x.setValue(hitch_pos_x);
                me.tug_pos_y.setValue(hitch_pos_y);
                me.aircraft_steering.setValue(aircraft_steering / me.steering_factor.getValue());

                me.tug_angle.setValue(tug_angle);
                setprop("sim/model/pushback/tug/turn-center-x", tug_turn_center_x);
                setprop("sim/model/pushback/tug/turn-center-y", tug_turn_center_y);
                setprop("sim/model/pushback/tug/steering-radius", tug_steering_radius);
                setprop("sim/model/pushback/tug/steering-circum", tug_steering_circum);
                setprop("sim/model/pushback/tug/fixing-radius", tug_fixing_radius);
                setprop("sim/model/pushback/tug/fixing-circum", tug_fixing_circum);
                setprop("sim/model/pushback/tug/hitch-radius", tug_hitch_radius);
                setprop("sim/model/pushback/tug/hitch-circum", tug_hitch_circum);
                setprop("sim/model/pushback/tug/turn-x", tug_turn_x);
                setprop("sim/model/pushback/tug/turn-y", tug_turn_y);
                setprop("sim/model/pushback/tug/turn-dist", tug_inter_dist);
                setprop("sim/model/pushback/tug/turn-angle", tug_inter_angle);
                setprop("sim/model/pushback/tug/intersect-x", intersect.x);
                setprop("sim/model/pushback/tug/intersect-y", intersect.y);

                setprop("sim/model/pushback/target/tug-angle", target_tug_angle);
                setprop("sim/model/pushback/target/tug-steering", target_tug_steering);
                setprop("sim/model/pushback/target/tug-delta-angle", delta_angle);
                setprop("sim/model/pushback/target/tug-delta-steering", delta_steering);
                setprop("sim/model/pushback/target/ac-delta-steering", ac_delta_steering);

### set camera view
                if (me.view_number.getValue() != nil and me.cur_view_number.getValue() == me.view_number.getValue()) {
                    var view_rel_x = math.cos(aircraft_steering) * me.hitch_distance.getValue() + math.cos(tug_angle) * me.view_tug_x.getValue();
                    var view_rel_y = math.sin(aircraft_steering) * me.hitch_distance.getValue() + math.sin(tug_angle) * me.view_tug_x.getValue();
                    var view_rel_z = me.view_tug_z.getValue();

                    var view_axis = me.view_angle.getValue() * math.pi / 180.0;
                    var view_x = me.view_init_x.getValue() + math.cos(view_axis) * view_rel_x + math.sin(view_axis) * view_rel_z;
                    var view_y = me.view_init_y.getValue() + view_rel_y;
                    var view_z = me.view_init_z.getValue() + math.sin(view_axis) * -view_rel_x + math.cos(view_axis) * view_rel_z;
                    var view_a = angle_pt_pt(view_x, view_y, me.view_look_to.getValue(), 0.0) * 180.0 / math.pi;

                    me.cur_view_x.setValue(view_x * -1.0);
                    me.cur_view_y.setValue(view_y);
                    me.cur_view_z.setValue(view_z);
                    me.cur_view_pitch.setValue(view_axis);
                    me.cur_view_heading.setValue(view_a * -1.0);
                }

### calculate axis steering
                if (me.axis0_steerable.getBoolValue() and !me.axis1_steerable.getBoolValue()) {
                    me.axis0_angle.setValue(tug_steering * -180.0 / math.pi);
                    me.axis1_angle.setValue(0.0);
                }
                else if (!me.axis0_steerable.getBoolValue() and me.axis1_steerable.getBoolValue()) {
                    me.axis0_angle.setValue(0.0);
                    me.axis1_angle.setValue(tug_steering *  180.0 / math.pi);
                }
                else if (me.axis0_steerable.getBoolValue() and me.axis1_steerable.getBoolValue()) {
                    me.axis0_angle.setValue(tug_steering * -90.0 / math.pi);
                    me.axis1_angle.setValue(tug_steering *  90.0 / math.pi);
                }
### speed of wheels
                if (tug_steering != 0.0) {
                    if (me.axis0_steerable.getBoolValue()) {
                        tug_axel0_speed = angle_driven * tug_steering_radius / me.timelaps.getValue();
                    } else {
                        tug_axel0_speed = angle_driven * tug_fixing_radius / me.timelaps.getValue();
                    }
                    if (me.axis1_steerable.getBoolValue()) {
                        tug_axel1_speed = angle_driven * tug_steering_radius / me.timelaps.getValue();
                    } else {
                        tug_axel1_speed = angle_driven * tug_fixing_radius / me.timelaps.getValue();
                    }
                }
                me.axis0_spin.setValue(tug_axel0_speed * 60.0 / me.axis0_circum.getValue());
                me.axis1_spin.setValue(tug_axel1_speed * 60.0 / me.axis1_circum.getValue());




            }
            else {
                setprop("controls/gear/brake-parking", 1.0);

                me.tug_pos_x.setValue(me.hitch_distance.getValue());
                me.tug_pos_y.setValue(0.0);
                me.tug_angle.setValue(0.0);
                me.tug_steering.setValue(0.0);
                me.aircraft_steering.setValue(0.0);
                me.axis0_angle.setValue(0.0);
                me.axis1_angle.setValue(0.0);

                var velocity = 0.0;
                if ( me.connect.getBoolValue() and me.position.getValue() < 0.999) { velocity = -1.0; }
                if (!me.connect.getBoolValue() and me.position.getValue() > 0.000) { velocity =  1.0; }
#                if (
#                    (!me.connect.getBoolValue() and me.position.getValue() < 0.001) or
#                    (me.connect.getBoolValue() and me.position.getValue() > 0.999)
#                ) { velocity =  0.0; }
                me.axis0_spin.setValue(velocity * 60.0 / me.axis0_circum.getValue());
                me.axis1_spin.setValue(velocity * 60.0 / me.axis0_circum.getValue());
            }
        }
        else {
            if (getprop("sim/current-view/view-number-raw") == 107) {
                setprop("sim/current-view/view-number-raw", 0);
            }
            if (getprop("sim/view[107]/enabled")) {
                setprop("sim/view[107]/enabled", 0);
            }
        }
    }

};

var PB = pushback.new();

var update_pushback = func() {
    PB.update();
    settimer(update_pushback,0);
}



var angle_pt_pt = func(from_x, from_y, to_x, to_y) {
    var delta_x = to_x - from_x;
    var delta_y = to_y - from_y;
    var angle = 0.0;

    if (delta_x == 0.0) {
        if (delta_y < 0.0) {
            angle = -math.pi / 2.0;
        } else {
            angle = math.pi / 2.0;;
        }
    }
    else {
        angle = math.atan(delta_y / delta_x);
        if (delta_x < 0.0) {
            if (delta_y < 0.0) { angle += -math.pi; }
            else { angle += math.pi; }
        }
    }
    return angle;
}

var intersect_arc_arc = func(dist, angle, radius1, radius2, angle_prev) {
    var pos = {x: 0.0, y: 0.0};
    var delta1 = (radius1 / dist) * radius1;
    var delta2 = (radius2 / dist) * radius2;
    var delta3 = dist - (delta1 + delta2);
    var dist_x = delta1 + (delta3 / 2.0);
    var dist_y = 0.0;

    if (dist_x < radius1) {
        dist_y = math.sqrt((radius1 * radius1) - (dist_x * dist_x));
    }
    else {
        dist_x = radius1;
        dist_y = 0.0;
    }
    pos.x = math.cos(angle) * dist_x;
    pos.y = math.sin(angle) * dist_x;
    var pos1x = pos.x + math.sin(angle) * dist_y;
    var pos1y = pos.y - math.cos(angle) * dist_y;
    var ang1 = abs(angle_pt_pt(0.0, 0.0, pos1x, pos1y) - angle_prev);
    var pos2x = pos.x - math.sin(angle) * dist_y;
    var pos2y = pos.y + math.cos(angle) * dist_y;
    var ang2 = abs(angle_pt_pt(0.0, 0.0, pos2x, pos2y) - angle_prev);
    if (ang1 < ang2) {
        pos.x = pos1x;
        pos.y = pos1y;
    } else {
        pos.x = pos2x;
        pos.y = pos2y;
    }
    return pos;
}

var intersect_line_arc = func(pos_x, pos_y, angle, radius) {
    var pos = {x: 0.0, y: 0.0};
    var pos_distance = math.sqrt((pos_x * pos_x) + (pos_y * pos_y));
    var pos_angle = angle_pt_pt(0.0, 0.0, pos_x, pos_y) - angle;

    pos.y = math.sin(pos_angle) * pos_distance;
    pos.x = math.sqrt((radius * radius) - (pos.y * pos.y));
    pos_angle = angle_pt_pt(0.0, 0.0, pos.x, pos.y) + angle;
    pos.x = math.cos(pos_angle) * radius;
    pos.y = math.sin(pos_angle) * radius;
    return pos;
}



setlistener("/sim/signals/fdm-initialized",
    func {
        settimer(update_pushback,2);
    }
);

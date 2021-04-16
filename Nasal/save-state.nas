
var citation_save_general = [
  "/controls/save-state/general",
  "/controls/save-state/fuel",
  "/controls/save-state/battery",
  "/controls/save-state/radios",
  "/controls/save-state/models",
  "/controls/save-state/circuitBreakers",
  "/engines/engine[0]/running-time-s",
  "/engines/engine[1]/running-time-s",
  "/sim/aircraft-class",
  "/sim/aircraft-operator",
  "/sim/dimensions/parkpos-offset-m",
  "/sim/dimensions/radius-m",
  "/sim/model/livery",
];

var citation_array_fuel = [
  "/consumables/fuel/fuel-gal_us-0",
  "/consumables/fuel/fuel-gal_us-1",
  "/sim/weight[0]/weight-lb",
  "/sim/weight[1]/weight-lb",
  "/sim/weight[2]/weight-lb",
  "/sim/weight[3]/weight-lb",
  "/sim/weight[4]/weight-lb",
];

var citation_array_battery = [
  "/systems/electrical/supplier/battery/percent-save",
];

var citation_array_models = [
  "/controls/human-models",
  "/sim/yokes-visible",
  "/controls/seat/armrests-pos",
  "/controls/flaps-stepped",
];

var citation_array_radios = [
  "/instrumentation/ctl22[0]/power-knob",
  "/instrumentation/comm[0]/frequencies/selected-mhz",
  "/instrumentation/comm[0]/frequencies/standby-mhz",
  "/instrumentation/comm[0]/volume-def",
  "/instrumentation/ctl22[1]/power-knob",
  "/instrumentation/comm[1]/frequencies/selected-mhz",
  "/instrumentation/comm[1]/frequencies/standby-mhz",
  "/instrumentation/comm[1]/volume-def",
  "/instrumentation/ctl32[0]/power-knob",
  "/instrumentation/nav[0]/frequencies/selected-mhz",
  "/instrumentation/nav[0]/frequencies/standby-mhz",
  "/instrumentation/nav[0]/volume",
  "/instrumentation/nav[0]/radials/selected-deg",
  "/instrumentation/ctl32[1]/power-knob",
  "/instrumentation/nav[1]/frequencies/selected-mhz",
  "/instrumentation/nav[1]/frequencies/standby-mhz",
  "/instrumentation/nav[1]/volume",
  "/instrumentation/nav[1]/radials/selected-deg",
  "/instrumentation/ctl62/power-knob",
  "/instrumentation/adf[0]/frequencies/selected-khz",
  "/instrumentation/adf[0]/frequencies/standby-khz",
  "/instrumentation/adf[0]/mode",
  "/instrumentation/adf[0]/volume-norm",
  "/instrumentation/ctl92/power-knob",
  "/instrumentation/transponder[0]/id-code",
  "/instrumentation/transponder[0]/inputs/knob-mode",
  "/instrumentation/transponder[1]/id-code",
  "/instrumentation/transponder[1]/inputs/knob-mode",
  "/instrumentation/airspeed-indicator[0]/index-marker",
  "/instrumentation/airspeed-indicator[1]/index-marker",
  "/instrumentation/clock/m877/mode-string",
  "/instrumentation/dme-339F-12A[0]/switch-mode",
  "/instrumentation/dme-339F-12A[0]/switch-nav",
  "/instrumentation/dme-339F-12A[0]/dim",
  "/instrumentation/dme-339F-12A[1]/switch-mode",
  "/instrumentation/dme-339F-12A[1]/switch-nav",
  "/instrumentation/dme-339F-12A[1]/dim",
  "/instrumentation/hsi[0]/heading-deg",
  "/instrumentation/hsi[1]/heading-deg",
  "/instrumentation/rmi[0]/single-needle/position-deg",
  "/instrumentation/rmi[0]/single-needle/selected-input",
  "/instrumentation/rmi[0]/double-needle/position-deg",
  "/instrumentation/rmi[0]/double-needle/selected-input",
  "/instrumentation/rmi[1]/single-needle/position-deg",
  "/instrumentation/rmi[1]/single-needle/selected-input",
  "/instrumentation/rmi[1]/double-needle/position-deg",
  "/instrumentation/rmi[1]/double-needle/selected-input",
  "/autopilot/ms-205[0]/panel/dim",
  "/autopilot/ms-205[1]/panel/dim",
  "/autopilot/source/heading-bug-deg",
  "/controls/lighting/flood-light-norm",
  "/controls/lighting/left-panel-norm",
  "/controls/lighting/center-panel-norm",
  "/controls/lighting/right-panel-norm",
  "/controls/lighting/instrument-light-norm",
  "/controls/lighting/altitude-alerter-dim",
];

var citation_array_circuitBreakers = [

# hot battery bus / located in J-Box #
  "/controls/electric/circuit-breakers/battery-hot/cb-light-comp",
  "/controls/electric/circuit-breakers/battery-hot/cb-light-emer",
  "/controls/electric/circuit-breakers/battery-hot/cb-ignition",
  "/controls/electric/circuit-breakers/battery-hot/cb-emer-power",

# battery bus / located in J-Box #
  "/controls/electric/circuit-breakers/battery/cb-batt-voltage",

# emergency bus / on right CB panel #
  "/controls/electric/circuit-breakers/emer/cb-dc-nav2",
  "/controls/electric/circuit-breakers/emer/cb-dc-comm1",
  "/controls/electric/circuit-breakers/emer/cb-dc-dg2",
  "/controls/electric/circuit-breakers/emer/cb-light-flood",

# left isolated bus / located in J-Box  #
  "/controls/electric/circuit-breakers/isolated-left/cb-gen-ammeter-left",
  "/controls/electric/circuit-breakers/isolated-left/cb-gen-sense-left",
  "/controls/electric/circuit-breakers/isolated-left/cb-light-start-left",
  "/controls/electric/circuit-breakers/isolated-left/cb-gen-voltage-left",

# left main bus / located in J-Box #
  "/controls/electric/circuit-breakers/main-left/cb-left-sense",
  "/controls/electric/circuit-breakers/main-left/cb-fuel-boost-left",
  "/controls/electric/circuit-breakers/main-left/cb-annun-genoff-left",
  "/controls/electric/circuit-breakers/main-left/cb-light-landing-left",
  "/controls/electric/circuit-breakers/main-left/cb-light-recog-left",
  "/controls/electric/circuit-breakers/main-left/cb-light-advisory",
  "/controls/electric/circuit-breakers/main-left/cb-light-indirect",
  "/controls/electric/circuit-breakers/main-left/cb-entertainment",

# left main bus / located on left CB panel #
  "/controls/electric/circuit-breakers/cb-main-left-1",
  "/controls/electric/circuit-breakers/cb-main-left-2",
  "/controls/electric/circuit-breakers/cb-main-left-3",

  "/controls/electric/circuit-breakers/main-left/cb-left-starter",
  "/controls/electric/circuit-breakers/main-left/cb-left-inverter",
  "/controls/electric/circuit-breakers/main-left/cb-left-xover",

  "/controls/electric/circuit-breakers/main-left/cb-engine-fan-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-itt-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-turbine-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-fuelflow-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-qty-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-oilt-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-oilp-left",

  "/controls/electric/circuit-breakers/main-left/cb-engine-ign-right",
  "/controls/electric/circuit-breakers/main-left/cb-fuel-boost-right",
  "/controls/electric/circuit-breakers/main-left/cb-engine-shutoff-left",
  "/controls/electric/circuit-breakers/main-left/cb-engine-fire-left",

  "/controls/electric/circuit-breakers/main-left/cb-sys-skid-ctrl",
  "/controls/electric/circuit-breakers/main-left/cb-sys-thrustrev-left",
  "/controls/electric/circuit-breakers/main-left/cb-sys-flap-motor",
  "/controls/electric/circuit-breakers/main-left/cb-sys-flap-ctrl",
  "/controls/electric/circuit-breakers/main-left/cb-sys-aoa",
  "/controls/electric/circuit-breakers/main-left/cb-sys-gear-ctrl",
  "/controls/electric/circuit-breakers/main-left/cb-sys-engine-sync",
  "/controls/electric/circuit-breakers/main-left/cb-sys-pitch-trim",
  "/controls/electric/circuit-breakers/main-left/cb-sys-nose-wheel-rpm",
  "/controls/electric/circuit-breakers/main-left/cb-sys-speed-brake",

  "/controls/electric/circuit-breakers/main-left/cb-anti-ice-pitot-left",
  "/controls/electric/circuit-breakers/main-left/cb-anti-ice-aoa",
  "/controls/electric/circuit-breakers/main-left/cb-anti-ice-engine-left",
  "/controls/electric/circuit-breakers/main-left/cb-anti-ice-bleedair-ws-temp",
  "/controls/electric/circuit-breakers/main-left/cb-anti-ice-bleedair-ws",

  "/controls/electric/circuit-breakers/main-left/cb-inst-gyro-standby",
  "/controls/electric/circuit-breakers/main-left/cb-inst-oat",
  "/controls/electric/circuit-breakers/main-left/cb-inst-clock-left",

  "/controls/electric/circuit-breakers/main-left/cb-env-normalp",
  "/controls/electric/circuit-breakers/main-left/cb-env-fan",
  "/controls/electric/circuit-breakers/main-left/cb-env-temp",

  "/controls/electric/circuit-breakers/main-left/cb-warn-batt",
  "/controls/electric/circuit-breakers/main-left/cb-warn-gear",
  "/controls/electric/circuit-breakers/main-left/cb-warn-lts1",

  "/controls/electric/circuit-breakers/main-left/cb-light-panel-left",
  "/controls/electric/circuit-breakers/main-left/cb-light-panel-el",
  "/controls/electric/circuit-breakers/main-left/cb-light-beacon",
  "/controls/electric/circuit-breakers/main-left/cb-light-strobe",
  "/controls/electric/circuit-breakers/main-left/cb-light-winginsp",
  "/controls/electric/circuit-breakers/main-left/cb-light-nav",

  "/controls/electric/circuit-breakers/main-left/cb-rec-flight",
  "/controls/electric/circuit-breakers/main-left/cb-rec-voice",

# left main x-over bus / located on right CB panel #
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-comm2",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-nav1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-dme1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-xpdr1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-adf1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-audio1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-phone",

  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-ap",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-efis-disp",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-efis-efis",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-efis-adi",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-efis-hsi",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-voice-adv",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-radalt",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-fd1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-rmi1",
  "/controls/electric/circuit-breakers/main-left-xover/cb-dc-dg1",

# right isolated bus / located in J-Box  #
  "/controls/electric/circuit-breakers/isolated-right/cb-gen-ammeter-right",
  "/controls/electric/circuit-breakers/isolated-right/cb-gen-sense-right",
  "/controls/electric/circuit-breakers/isolated-right/cb-light-start-right",
  "/controls/electric/circuit-breakers/isolated-right/cb-gen-voltage-right",

# right main bus / located in J-Box #
  "/controls/electric/circuit-breakers/main-right/cb-right-sense",
  "/controls/electric/circuit-breakers/main-right/cb-fuel-boost-right",
  "/controls/electric/circuit-breakers/main-right/cb-annun-genoff-right",
  "/controls/electric/circuit-breakers/main-right/cb-light-landing-right",
  "/controls/electric/circuit-breakers/main-right/cb-light-recog-right",
  "/controls/electric/circuit-breakers/main-right/cb-light-cabin",
  "/controls/electric/circuit-breakers/main-right/cb-light-toilet",

# right main bus / located on right CB panel #
  "/controls/electric/circuit-breakers/cb-main-right-1",
  "/controls/electric/circuit-breakers/cb-main-right-2",
  "/controls/electric/circuit-breakers/cb-main-right-3",

  "/controls/electric/circuit-breakers/main-right/cb-right-starter",
  "/controls/electric/circuit-breakers/main-right/cb-right-inverter",
  "/controls/electric/circuit-breakers/main-right/cb-right-xover",

  "/controls/electric/circuit-breakers/main-right/cb-engine-fan-right",
  "/controls/electric/circuit-breakers/main-right/cb-engine-itt-right",
  "/controls/electric/circuit-breakers/main-right/cb-engine-turbine-right",
  "/controls/electric/circuit-breakers/main-right/cb-engine-fuelflow-right",
  "/controls/electric/circuit-breakers/main-right/cb-engine-qty-right",
  "/controls/electric/circuit-breakers/main-right/cb-engine-oilt-right",
  "/controls/electric/circuit-breakers/main-right/cb-engine-oilp-right",

  "/controls/electric/circuit-breakers/main-right/cb-dc-dme2",
  "/controls/electric/circuit-breakers/main-right/cb-dc-xpdr2",
  "/controls/electric/circuit-breakers/main-right/cb-dc-adf2",
  "/controls/electric/circuit-breakers/main-right/cb-dc-audio2",
  "/controls/electric/circuit-breakers/main-right/cb-dc-warn",
  "/controls/electric/circuit-breakers/main-right/cb-dc-comm3",
  "/controls/electric/circuit-breakers/main-right/cb-dc-nav-area",
  "/controls/electric/circuit-breakers/main-right/cb-dc-gpws",
  "/controls/electric/circuit-breakers/main-right/cb-dc-tas-htr",
  "/controls/electric/circuit-breakers/main-right/cb-dc-nav-vlf",
  "/controls/electric/circuit-breakers/main-right/cb-dc-nav-db",
  "/controls/electric/circuit-breakers/main-right/cb-dc-fms",

  "/controls/electric/circuit-breakers/main-right/cb-dc-radar",
  "/controls/electric/circuit-breakers/main-right/cb-dc-fd2",
  "/controls/electric/circuit-breakers/main-right/cb-dc-rmi2",

# right main x-over bus / located on left CB panel #
  "/controls/electric/circuit-breakers/main-right-xover/cb-engine-ign-left",
  "/controls/electric/circuit-breakers/main-right-xover/cb-fuel-boost-left",
  "/controls/electric/circuit-breakers/main-right-xover/cb-engine-shutoff-right",
  "/controls/electric/circuit-breakers/main-right-xover/cb-engine-fire-right",

  "/controls/electric/circuit-breakers/main-right-xover/cb-env-emerp",

  "/controls/electric/circuit-breakers/main-right-xover/cb-inst-ralt",
  "/controls/electric/circuit-breakers/main-right-xover/cb-inst-flt-hr",
  "/controls/electric/circuit-breakers/main-right-xover/cb-inst-clock-right",

  "/controls/electric/circuit-breakers/main-right-xover/cb-anti-ice-pitot-right",
  "/controls/electric/circuit-breakers/main-right-xover/cb-anti-ice-engine-right",
  "/controls/electric/circuit-breakers/main-right-xover/cb-anti-ice-surface",
  "/controls/electric/circuit-breakers/main-right-xover/cb-anti-ice-alcohol",

  "/controls/electric/circuit-breakers/main-right-xover/cb-warn-lts2",
  "/controls/electric/circuit-breakers/main-right-xover/cb-warn-speed",

  "/controls/electric/circuit-breakers/main-right-xover/cb-sys-equip-cool",
  "/controls/electric/circuit-breakers/main-right-xover/cb-sys-thrustrev-right",

  "/controls/electric/circuit-breakers/main-right-xover/cb-light-panel-center",
  "/controls/electric/circuit-breakers/main-right-xover/cb-light-panel-right",


# AC-115V bus / located on right CB panel #
  "/controls/electric/circuit-breakers/AC-115V/cb-ac-ap",
  "/controls/electric/circuit-breakers/AC-115V/cb-ac-fd1",
  "/controls/electric/circuit-breakers/AC-115V/cb-ac-air-data",
  "/controls/electric/circuit-breakers/AC-115V/cb-ac-vgyro1",
  "/controls/electric/circuit-breakers/AC-115V/cb-ac-radar",

  "/controls/electric/circuit-breakers/AC-115V/cb-ac-fd2",
  "/controls/electric/circuit-breakers/AC-115V/cb-ac-vgyro2",

# AC-26V bus / located on right CB panel #
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-nav1",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-rmi-adf1",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-hsi1",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-adi1",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-gpws",

  "/controls/electric/circuit-breakers/AC-26V/cb-ac-nav2",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-rmi-adf2",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-hsi2",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-adi2",
  "/controls/electric/circuit-breakers/AC-26V/cb-ac-efis",

];

var reset_circuitBreakers = func() {
  foreach(var path; citation_array_circuitBreakers) {
    setprop(path, 1);
  }
  screen.log.write("All circuit-breakers reset to closed.");
}


var switchProp = func(which) {
  if (getprop("/controls/save-state/" ~ which)) {
    setprop("/controls/save-state/" ~ which, 0);
  }
  else {
    setprop("/controls/save-state/" ~ which, 1);
  }
  saveState.update_saveState();
}


var update_saveState = func() {

  aircraft.data.catalog = [];

  aircraft.data.add(citation_save_general);

  if (getprop("/controls/save-state/general")) {
    if (getprop("/controls/save-state/fuel")) {
      aircraft.data.add(citation_array_fuel);
    }

    if (getprop("/controls/save-state/battery")) {
      aircraft.data.add(citation_array_battery);
    }

    if (getprop("/controls/save-state/models")) {
      aircraft.data.add(citation_array_models);
    }

    if (getprop("/controls/save-state/radios")) {
      aircraft.data.add(citation_array_radios);
    }

    if (getprop("/controls/save-state/circuitBreakers")) {
      aircraft.data.add(citation_array_circuitBreakers);
    }
#    aircraft.data.save();
  }
}

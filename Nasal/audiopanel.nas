var audiopnl = {};

audiopnl.new = func(rootPath) {
    var obj = {};
    obj.parents = [audiopnl];

    setlistener(rootPath ~ "/marker", func(v) {setprop("/instrumentation/marker-beacon/audio-btn" ,(v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/warn",   func(v) {setprop("/instrumentation/warn/volume",             (v.getValue() != 1));}, 1);
    setlistener(rootPath ~ "/adf1",   func(v) {setprop("/instrumentation/adf[0]/ident-audible",    (v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/adf2",   func(v) {setprop("/instrumentation/adf[1]/ident-audible",    (v.getValue() != 1));}, 1);
    setlistener(rootPath ~ "/dme1",   func(v) {setprop("/instrumentation/dme[0]/ident",            (v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/dme2",   func(v) {setprop("/instrumentation/dme[1]/ident",            (v.getValue() != 1));}, 1);
    setlistener(rootPath ~ "/nav1",   func(v) {setprop("/instrumentation/nav[0]/audio-btn",        (v.getValue() != 1));}, 1);
    setlistener(rootPath ~ "/nav2",   func(v) {setprop("/instrumentation/nav[1]/audio-btn",        (v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/resv0",  func(v) {setprop("/instrumentation/",                        (v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/resv1",  func(v) {setprop("/instrumentation/",                        (v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/resv2",  func(v) {setprop("/instrumentation/",                        (v.getValue() != 1));}, 1);
#    setlistener(rootPath ~ "/mute",   func(v) {setprop("/instrumentation/",                        (v.getValue() != 1));}, 1);
    print( "Audiopanel initialized" );
    return obj;
};

var audiopnl_0 = audiopnl.new( "/instrumentation/audiopanel" );

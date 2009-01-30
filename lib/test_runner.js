// NOTE: This script expects to be ran from the #{RAILS_ROOT}/test/javascript directory!

if(arguments.length == 0) {
  print("Usage: test_runner.js /test/javascript/spec_file.js");
  quit(1);
}

function require(file, options) { 
  load(file); 
  
  options = options || {};
  if(options['onload']) {
    options['onload'].call();
  }
}

function debug(message) {
  print(message);
}

// Mock up the Firebug API for convenience.
var console = {debug:debug};

var spec_file = arguments[0];
var fixture = "fixtures/" + spec_file.replace(/^(.*?)_spec\.js$/, "$1.html");
print("Running " + spec_file + " with fixture '" + fixture + "'...");

var RAILS_ROOT_PREFIX = "../../";
var PLUGIN_PREFIX = RAILS_ROOT_PREFIX + "/vendor/plugins/javascript_testing/";


load(PLUGIN_PREFIX + "lib/env.rhino.js");
window.location = fixture;

load(PLUGIN_PREFIX + "lib/jquery-1.2.6.js");
// load(PLUGIN_PREFIX + "lib/jquery-1.3.1.js");
jQuery.noConflict();

load(PLUGIN_PREFIX + "lib/jquery.fn.js");
load(PLUGIN_PREFIX + "lib/jquery.print.js");
load(PLUGIN_PREFIX + "lib/screw.builder.js");
load(PLUGIN_PREFIX + "lib/screw.matchers.js");
load(PLUGIN_PREFIX + "lib/screw.events.js");
load(PLUGIN_PREFIX + "lib/screw.behaviors.js");
load(PLUGIN_PREFIX + "lib/consoleReportForRake.js");

load(spec_file);
jQuery.ready();

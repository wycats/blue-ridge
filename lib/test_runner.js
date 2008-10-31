// NOTE: This script expects to be ran from the #{RAILS_ROOT}/test/javascript directory!

if(arguments.length == 0) {
  print("Usage: test_runner.js /test/javascript/spec_file.js");
  quit(1);
}

function require(file) { 
  load(file); 
}

spec_file = arguments[0];
fixture = "html/" + spec_file.replace(/^(.*?)_spec\.js$/, "$1.html");
print("Running " + spec_file + " with fixture '" + fixture + "'...");

RAILS_ROOT_PREFIX = "../../";
PLUGIN_PREFIX = RAILS_ROOT_PREFIX + "/vendor/plugins/javascript_testing/";

load(PLUGIN_PREFIX + "lib/env.js");
window.location = fixture;
load(RAILS_ROOT_PREFIX + "public/javascripts/prototype.js");
load(PLUGIN_PREFIX + "lib/prototypeForJsspec.js");
load(PLUGIN_PREFIX + "lib/jsspec.js");
load(PLUGIN_PREFIX + "lib/consoleReportForRake.js");

load(spec_file);

Specs.report = "ConsoleReport";
Specs.run();

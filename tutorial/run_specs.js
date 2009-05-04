Johnson.load(PLUGIN_PREFIX + "/lib/jquery.fn.js");
Johnson.load(PLUGIN_PREFIX + "/lib/jquery.print.js");
Johnson.load(PLUGIN_PREFIX + "/tutorial/public/wycats.js");
Johnson.load(PLUGIN_PREFIX + "/tutorial/public/tabs.js");
Johnson.load(PLUGIN_PREFIX + "/lib/screw.builder.js");
Johnson.load(PLUGIN_PREFIX + "/lib/screw.matchers.js");
Johnson.load(PLUGIN_PREFIX + "/lib/screw.events.js");
Johnson.load(PLUGIN_PREFIX + "/lib/screw.behaviors.js");
Johnson.load(PLUGIN_PREFIX + "/lib/smoke.core.js");
Johnson.load(PLUGIN_PREFIX + "/lib/smoke.mock.js");
Johnson.load(PLUGIN_PREFIX + "/lib/smoke.stub.js");
Johnson.load(PLUGIN_PREFIX + "/lib/screw.mocking.js");
Johnson.load(PLUGIN_PREFIX + "/lib/consoleReportForRake.js");
Johnson.load(PLUGIN_PREFIX + "/tutorial/tabs_spec.js");

jQuery.ajaxSetup({async: false});
jQuery(document).trigger("ready")
jQuery(window).trigger("load");
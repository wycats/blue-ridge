function require(url, options) {
  //this function expects to be ran from the context of the test/javascript/fixtures
  //directory, so add a '../' prefix to all Javascript paths
  url = "../" + url;
  
  var head = document.getElementsByTagName("head")[0];
  var script = document.createElement("script");
  script.src = url;
  
  options = options || {};
  
  if (options['onload']) {
    // Attach handlers for all browsers
    script.onload = script.onreadystatechange = options['onload'];
  }
  
  head.appendChild(script);
}

function derive_spec_name_from_current_file() {
  var file_prefix = new String(window.location).match(/.*\/(.*?)\.html$/)[1];
  return file_prefix + "_spec.js";
}

require("../../public/javascripts/prototype.js", {onload:function() {
  require("../../vendor/plugins/javascript_testing/lib/jsspec.js", {onload:function() {
    require(derive_spec_name_from_current_file(), {onload:function() {
      Event.observe(window, 'load', function() {
        Specs.run();
      });
    }});
  }});
}});

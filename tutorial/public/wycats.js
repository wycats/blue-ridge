// Run a set of functions passed in by the user against
// the jQuery object that is being set up in the plugin
// and the options that were passed in by the user for
// the plugin.
//
// Example:
//
//   $.fn.simplePlugin = function(options) {
//     this.setupPlugin(options.setup);
//   
//     this.click(function() {
//       $(this).trigger("activated", $(this).html());
//     })
//   }
//   
//   var logger = {
//     click: function(options) {
//       logText = options.text;
//       this.bind("activated", function(e, html) { 
//         console.log(text + ": " + html); 
//       })
//     } 
//   }
//   
//   $("div").simplePlugin({setup: logger, text: "LOG"});
//
// When the plugin is activated, the functions in logger are called,
// passing in the user options. In this case, all divs on the page
// will output "LOG: #{their innerHTML}" when clicked on.
//
// The purpose of this plugin is to make it easier to separate the core
// functionality of a plugin from its auxiliary parts. In particular, it
// makes it easy to split out the basic, low-level event handling from 
// the high-level event handling, and makes it easier to provide alternative 
// or modified implementations of the default high-level event handlers
// that are provided with a plugin.
//
// It is expected that plugin authors provide a default setup
// implementation, preferably stored in $.fn.pluginName.base or something
// like that.
//
// Note that in addition to supporting single functions bound to specific
// names, setupPlugin also supports arrays of functions. This makes it
// easier for modifications to be made to the default setup that require
// inserting a function *before* the one provided by default, but still
// maintaining the default behavior as well. As a result, the preferred
// usage is:
// 
//   var logger = {
//     click: [function(options) {
//       logText = options.text;
//       this.bind("activated", function(e, html) { 
//         console.log(text + ": " + html); 
//       })
//     }]
//   }
jQuery.fn.setupPlugin = function(setup, options) {
  for(extra in setup) {
    var self = this;
    if(setup[extra] instanceof Array) {
      for(var i=0; i<setup[extra].length; i++) 
        setup[extra][i].call(self, options);
    } else {
      setup[extra].call(self, options);
    }
  }
};

// Returns an object that is bound to the first element matching the
// selector. $$ takes the same first parameter as jQuery.
//
// If you wish to add methods to the $$ object, note that the original 
// node is available as this.node inside $$ function.
//
// Example:
//
//  $$("#myDiv").update = function() {
//    $(this.node).load(this.node.rel);
//  }
//
//  $$("#myDiv").update();
//
// Note that properties and methods will only be bound to a single
// element. This effectively allows the promotion of an element
// node to a full-fledged object with stateful properties and
// methods.
var $$ = function(param) {
  var node = $(param)[0];
  var id = $.data(node);
  $.cache[id] = $.cache[id] || {};
  $.cache[id].node = node;
  return $.cache[id];
};
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

var $$ = function(param) {
  var node = $(param)[0];
  var id = $.data(node);
  $.cache[id] = $.cache[id] || {};
  $.cache[id].node = node;
  return $.cache[id];
};
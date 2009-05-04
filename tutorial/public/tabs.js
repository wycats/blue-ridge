jQuery(function($) {
  $.fn.tabs = function(options) {
    options = options || {};
    this.setupPlugin(options.setup || $.fn.tabs.base, options);
  };
  
  $.fn.tabs.base = {
    
  };
});
jQuery(function($) {
  $("ul.tabs").tabs({setup: $.fn.tabs.tutorial, xhr: {"#second": "/second"}});    
});
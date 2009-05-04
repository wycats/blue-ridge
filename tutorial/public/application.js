jQuery(function($) {
  $("ul.tabs").tabs({setup: $.fn.tabs.wycats, xhr: {"#second": "/second"}});    
});
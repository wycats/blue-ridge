jQuery(function($) {  
  $.fn.tabs = function(options) {
    options = options || {};
    
    this.setupPlugin(options.setup || $.fn.tabs.base, options);
    
    // Initialize
    this.each(function() {
      var tabList = $(this);
      $$(tabList).panels = $([]);
      $$(tabList).tabs = function(filter) { 
        var nodes = $(this.node).find("li a");
        if(filter) nodes = nodes.filter("[href='" + filter + "']");
        return nodes;
      };
      
      $("li a", tabList)
        .click(function() {
          tabList.trigger("activated", this);
          return false;
        }).each(function() {
          var panel = $$(this).panel = $($(this).attr("href"));
          $$(tabList).panels = $$(tabList).panels.add(panel);
        });
        
      tabList.trigger("initialize");
    });
    
    return this;
  };
  
  $.fn.tabs.base = {
    setupTabs: [function(options) {
      this.bind("initialize", function() {
        $$(this).panels.each(function() { $(this).hide(); });
      });
    }],
    
    initialize: [function(options) {
      this.bind("initialize", function() {
        $$(this).panels.each(function() { $(this).hide(); });
        var firstTab = $(this).find("li a:first")[0];
        $(this).trigger("activated", firstTab);
      });
    }],
    
    activate: [function(options) {
      this.bind("activated", function(e, selected) {
        var panel = $$(selected).panel;
        $$(this).panels.hide();
        $(panel).show();
        $(this).find("li a").removeClass("active");
        $(selected).addClass("active").blur();
      });
    }]
  };
  
  var tutorial = $.fn.tabs.tutorial = $.extend({}, $.fn.tabs.base);
  tutorial.activate.unshift(function(options) {
    var xhr = options.xhr;
    this.bind("activated", function(e, selected) {
      var url = xhr && xhr[$(selected).attr("href")];
      if(url) {
        $$(selected).panel.html("<img src='throbber.gif'/>").load(url);
      }
    });
  });
  
  delete tutorial.initialize;
  
  tutorial.hash = [function(options) {
    var container = this;
    
    this.bind("initialize", function() {
      $(this).trigger("activated", $$(this).tabs(window.location.hash)[0]);
    });
    
    this.bind("activated", function(e, selected) {
      window.location.hash = $(selected).attr("href");
    });
            
    var lastHash = window.location.hash;
    setInterval(function() {
      if(lastHash != window.location.hash) {
        var tab = $$(container).tabs(window.location.hash);
        if(!tab.is(".active")) $(container).trigger("activated", tab[0]);
        lastHash = window.location.hash;
      }
    }, 500);    
  }];    
});
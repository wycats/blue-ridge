Screw.FiredEvents = {};

// Global Setup
jQuery(function($) {
  $("ul.tabs").bind("initialize", function(e) {
    Screw.FiredEvents.initialize = e;
  });
  
  $("ul.tabs").bind("activated", function(e, selected) {
    Screw.FiredEvents.activated = {event: e, selected: selected};
  });
  
  $.fn.tabs.wycats = $.fn.tabs.wycats || $.fn.tabs.base;
  $("ul.tabs").tabs({setup: $.fn.tabs.wycats, xhr: {"#second": "/second"}});
});

// Specs
Screw.Unit(function(){
  describe("The Base Tab Plugin", function() {
    it("collects the panels into $$('ul.tabs').panels", function() {
      expect($$("ul.tabs").panels).to(equal, $("#first, #second, #third"));
    });
    
    it("makes the tabs available as $$('ul.tabs').tabs()", function() {
      expect($$("ul.tabs").tabs()).to(equal, $("ul.tabs li a"));
    });
    
    it("allows filtering of tabs via $$('ul.tabs').tabs('#first')", function() {
      expect($$("ul.tabs").tabs("#second")).to(equal, $("ul.tabs li a[href='#second']"));
    });
    
    it("triggers an initialize event when it is done setting things up", function() {
      expect(Screw.FiredEvents.initialize).to_not(be_undefined);
    });
    
    it("triggers an activated event when a tab is clicked", function() {
      expect($(Screw.FiredEvents.activated.selected)).to(equal, $("a[href='#first']"));
    });
  });
  
  describe("The basic event handlers", function() {
    it("hides all but the first panel on initialization", function() {
      expect($("div.environments > div:eq(0)")).to(match_selector, ":visible");
      expect($("div.environments > div:eq(1)")).to_not(match_selector, ":visible");
      expect($("div.environments > div:eq(2)")).to_not(match_selector, ":visible");
    });
    
    it("marks the first tab 'active'", function() {
      expect($("a[href='#first']")).to(match_selector, ".active");
      expect($("a[href='#second']")).to_not(match_selector, ".active");
      expect($("a[href='#third']")).to_not(match_selector, ".active");
    });
    
    describe("when clicking a tab", function() {
      before(function() {
        $("a[href='#second']").click();
      });
      
      it("hides all but the second panel", function() {
        expect($("div.environments > div:eq(0)")).to_not(match_selector, ":visible");
        expect($("div.environments > div:eq(1)")).to(match_selector, ":visible");
        expect($("div.environments > div:eq(2)")).to_not(match_selector, ":visible");
      });
      
      it("deactivates the first tab and activates the second", function() {
        expect($("a[href='#first']")).to_not(match_selector, ".active");
        expect($("a[href='#second']")).to(match_selector, ".active");
        expect($("a[href='#third']")).to_not(match_selector, ".active");
      });
    });
  });
  
  describe("An XHR extension", function() {
    before(function() {
      $("a[href='#second']").click();
    });
    
    it("puts the resulting text into the corresponding panel", function() {
      expect($("#second").html()).to(equal, "omg");
    });
  })
});

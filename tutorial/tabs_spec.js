Screw.Unit(function(){
  describe("Your application javascript", function(){
    it("activates the first tab", function() {
      expect(jQuery("a[href='#first']").is(".active")).to(equal, true);
      expect(jQuery("a[href='#second']").is(":not(.active)")).to(equal, true);
    });

    it("activates a tab when it's clicked", function() {
      $("a[href='#second']").click();
      expect(jQuery("a[href='#second']").is(".active")).to(equal, true);
    });
    
    it("changes the hash when clicked", function() {
      $("a[href='second']").click();
      expect(window.location.hash).to(equal, "#second")
    });
    
  });
});

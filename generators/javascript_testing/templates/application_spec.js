require("spec_helper.js");
require("../../public/javascripts/prototype.js");

Screw.Unit(function() {
  describe("Your application javascript", function() {
    it("should do something", function() {
      expect("hello").to(equal, "hello");
    });

    it("Prototype's $$ selector should find only elements with the provided class selector", function() {
      expect($$('.select_me').length).to(equal, 2);
    });
  });
});


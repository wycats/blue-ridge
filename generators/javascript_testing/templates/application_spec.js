require("spec_helper.js");

with(Spec) {
  describe("Your application javascript", function() { with(this) {
    it("should do something", function() {
      "hello".should(equal("hello"));
    });
     
    it("Prototype's $$ selector should find only elements with the provided class selector", function() {
      ($$('.select_me').length).should(equal(2));
    });
  }});
};

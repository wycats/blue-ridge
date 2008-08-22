load("config.js"); 
// window.location = "fixtures/application.html";
load("jsspec/jsspec.js");

with(Spec) {  
   describe("Your application javascript", function() { with(this) {  

     it("should do something", function() {  
       // Do something interesting here.
     });

   }});
};

Specs.report = "ConsoleReport";  
Specs.run();
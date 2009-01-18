$(Screw).bind("before", function() {
    function example_name(element) {
      // TODO: handle nested describes!
      var context_name = $(element).parents(".describe").children("h1").text();
      var example_name = $(element).children("h2").text();
      
      return context_name + " - " + example_name;
    }
    
    $('.it')
      .bind('passed', function() { 
        print(".");
      })
      .bind('failed', function(e, reason) {
        print("FAILED: " + example_name(this));
        print("          " + reason + "\n");
      });
});

$(Screw).bind("after", function() {
  var testCount = $('.passed').length + $('.failed').length;
  var failures = $('.failed').length;
  var elapsedTime = ((new Date() - Screw.suite_start_time)/1000.0);
  print(testCount + ' test(s), ' + failures + ' failure(s)');
  print(elapsedTime.toString() + " seconds elapsed");
  
  if(failures > 0) {
    var exceptionString = (failures == 1) ? "1 test failed!" : failures + " tests failed!";
    throw exceptionString;
  };
});

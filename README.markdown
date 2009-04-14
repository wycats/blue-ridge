JavaScript Testing
==================

The JavaScript Testing Rails Plugin adds support for command-line and in-browser JavaScript unit testing to your Rails app.


Installing and Running
----------------------

To install:

    rails_project> ./script/plugin install git://github.com/relevance/javascript_testing.git
    rails_project> ./script/generate javascript_testing
  
This will create one of the following directories:

* `examples/javascripts`: if you're using [Micronaut](http://github.com/spicycode/micronaut)
* `spec/javascripts`: if you're using [RSpec]()
* `test/javascript`: if you're using anything else

To run all of the specs:

   rails_project> rake test:javascripts
  
(Hint: You can also use `spec:javascripts` or `examples:javascripts`.  They're all the same.)
  
To run an individual spec file "selector_spec.js":

  rails_project> rake test:javascripts TEST=selector
  

Example using jQuery (the default)
----------------------------------

    require("spec_helper.js");
    require("../../public/javascripts/application.js");

    Screw.Unit(function() {
      describe("Your application javascript", function() {
        it("does something", function() {
          expect("hello").to(equal, "hello");
        });

        it("accesses the DOM from fixtures/application.html", function() {
          expect($('.select_me').length).to(equal, 2);
        });
      });
    });



Example using Prototype
-----------------------

We don’t actually encourage you to write specs and tests for standard libraries like Prototype, JQuery, etc. It just makes for an easy demo.

In test/javascript/fixtures/selector.html

    <html>
    <body>
    <div class="select_me"/>
    <span class="select_me"/>
    <div class="dont_select_me"/>
    </body>
    </html>
  
In test/javascript/selector_spec.js

    jQuery.noConflict();
    require("spec_helper.js");
    require("../../public/javascripts/prototype.js", {onload: function() {
        require("../../public/javascripts/application.js");
    }});

    Screw.Unit(function() {
        describe("Your application javascript", function() {
            it("does something", function() {
                expect("hello").to(equal, "hello");
            });

            it("accesses the DOM from fixtures/application.html", function() {
                expect($$('.select_me').length).to(equal, 2);
            });
        });
    });

  
JavaScript API
--------------

... API: require, etc ...  

Extras 
-------------

.. js:fixtures ..
.. js:shell ..

Mocking Example with Smoke
--------------------------

TBD

Links
-------------
* [http://github.com/relevance/javascript_testing](http://github.com/relevance/javascript_testing)
* [http://blog.thinkrelevance.com/2008/7/31/fully-headless-jsspec](http://blog.thinkrelevance.com/2008/7/31/fully-headless-jsspec)
* link to screw.unit
* link to smoke
* link to env.js
* link to rhino

Contributors
------------
* Justin Gehtland
* Geof Dagley
* Larry Karnowski
* Chris Thatcher (for numerous env.js bug fixes!)
* Raimonds Simanovskis
* Jason Rudolph

Copyrights
------------
* Copyright &copy; 2008-2009 Relevance, Inc., under the MIT license
* env.js     - Copyright 2007-2009 John Resig, under the MIT License
* Screw.Unit - Copyright 2008 Nick Kallen, license attached
* Rhino      - Copyright 2009 Mozilla Foundation, GPL 2.0
* Smoke      - Copyright 2008 Andy Kent, license attached

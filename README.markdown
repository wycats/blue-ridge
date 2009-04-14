JavaScript Testing
==================

The JavaScript Testing Rails Plugin adds support for command-line and in-browser JavaScript unit testing to your Rails app. 
The plugin uses a behaviour-driven development toolkit called `Screw.Unit` that has a syntax similar to Ruby's `RSpec`.


Installing and Running
----------------------

To install:

    ./script/plugin install git://github.com/relevance/javascript_testing.git
    ./script/generate javascript_testing
  
To run all of the specs:

    rake test:javascripts
  
(Hint: You can also use `spec:javascripts` or `examples:javascripts`.  They're all the same.)
  
To run an individual spec file called "selector_spec.js":

    rake test:javascripts TEST=selector

Directory Layout: Specs and Fixtures
-------------------------------------

(why we need fixtures)  

* env.js needs it to run from command line (elaborate)
* makes it easy to run inside browser
* one fixture per spec file

This will create one of the following directories:

* `examples/javascripts`: if you're using [Micronaut](http://github.com/spicycode/micronaut)
* `spec/javascripts`: if you're using [RSpec]()
* `test/javascript`: if you're using anything else

(support for Micronaut, RSpec, etc.)

In test/javascript/fixtures/selector.html

    <html>
      <body>
        <div class="select_me"/>
        <span class="select_me"/>
        <div class="dont_select_me"/>
      </body>
    </html>
  
(anatomy of a fixture)
(creating HTML fixtures, fixture replacement example)

Example Spec using jQuery (the default)
---------------------------------------

This plugin is opinionated and assumes you're using jQuery by default.  The plugin itself actually uses jQuery under the covers to run Screw.Unit.

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

(By the way, we don’t actually encourage you to write specs and tests for standard libraries like JQuery and Prototype. It just makes for an easy demo.)

Example using Prototype
-----------------------

It's very easy to add support for Prototype, however.  Here's an example:

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

Note that you must do the following:

* put jQuery into "no conflict" mode to give the `$` function back to Prototype
* require the `prototype.js` file
* chain any files that are dependent on `prototype.js` being load in an `onload`
  
JavaScript API
--------------

The JavaScript Testing Rails Plugin provides a small API that lets you write specs that can run correctly inside a web browser as well from the Rhino command-line test runner.

### require
When running from the command line, `require` becomes a Rhino call to `load`, but in a web browser, it dynamically creates a JavaScript `script` tag and loads your given file for you.

... onload explanation and example ... 

### debug
When running from the command line, `debug` simply prints a message to stdout, but in a web browser it outputs into the DOM directly.

### console.debug
As a big fan of Firebug, I often have a `console.debug` function call in my tests to debug a problem.  Calling this from the command-line however, would blow up.  
To make my life a little easier, this `console.debug` is just an alias to Rhino's `print` which write text to stdout.

Extras
-------------

### rake js:fixtures
If you're on a Macintosh computer, this command opens your JavaScript fixtures directory using Finder to make running specs from a browser a bit easier.  
If you're on Linux, it opens the same directory using Firefox.

### rake js:shell
Runs an IRB-like JavaScript shell for debugging your JavaScript code.  jQuery and env.js are pre-loaded for you to make debugging DOM code easy.


Mocking Example with Smoke
--------------------------

...TBD....

Tips & Tricks
-------------
* (avoid `print` in your tests; it works fine from command line but causes lots of headaches in browser)
* don't test jQuery or Prototype, especially event wiring... instead write a separate function, test it, and wire it to events

Caveats
----------
env.js and jQuery 1.3.x do not currently get along well, so the JavaScript Testing Rails Plugin currently uses jQuery 1.2.6 to run command line specs.


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

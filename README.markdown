JavaScript Testing
==================

The JavaScript Testing Rails Plugin adds support for command-line and in-browser JavaScript unit testing to your Rails app by bundling several great tools together like Rhino, env.js, Screw.Unit, and Smoke.  Write your JavaScript code in a behaviour-driven development in an opinionated, convention-over-configuration Rails-like way, just like you write your Ruby code.

Installing and Running
----------------------

To install:

    ./script/plugin install git://github.com/relevance/javascript_testing.git
    ./script/generate javascript_testing
  
To run all of the specs:

    rake test:javascripts
  
(Hint: You can also use the `spec:javascripts` or `examples:javascripts` aliases.)
  
To run an individual spec file called "application_spec.js":

    rake test:javascripts TEST=application
    
To generate a spec for a JavaScript file called "public/javascripts/graphics.js" run:

    ./script/generate javascript_spec graphics
    rake test:javascripts TEST=graphics

To run your spec inside a web browser, load the appropriate `HTML fixture` (see below).

Directory Layout: Specs and Fixtures
-------------------------------------

### JavaScript Spec Directories

The plugin creates a JavaScript spec directories under one of the following directories, depending on which tool you use to test your Ruby code:

* examples/javascripts: if you're using [Micronaut](http://github.com/spicycode/micronaut)
* spec/javascripts: if you're using [RSpec](http://rspec.info/)
* test/javascript: if you're using anything else

The layout of the JavaScript spec directories looks like this:

#### "javascripts" directory
* application_spec.js: file with Screw.Unit specs
* graphics_spec.js: another spec file
* spec_helper.js: auto-included by each spec for common config & convenience functions
    
#### "javascripts/fixtures" directory
* application.html: base DOM for application_spec.js, also runs specs in-browser
* graphics.html: base DOM for graphics_spec.js, also runs specs in-browser
* screw.css: style Screw.Unit output while running specs in-browser

### Why We Need Fixtures
This plugin relies on the convention that each spec file will have a similarly named HTML file in the `fixtures` directory.  We create one fixture per spec file so that env.js has a base DOM to emulate when running specs from the command line and so that we have an HTML launch-pad to run our specs in-browser.  

If you want to have specific HTML for a suite of specs, put it in the HTML fixture for that suite.  If you want to run a specific suite of tests in Firefox or Internet Explorer, open the HTML fixture file with the same name and Screw.Unit automatically runs.

Example Using jQuery
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

Example Using Prototype
-----------------------

It's very easy to add support for Prototype.  Here's an example:

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
* chain any files that are dependent on `prototype.js` in the `onload` callback
  
JavaScript API
--------------

The JavaScript Testing Rails Plugin provides a small number of functions that help you write specs that run correctly inside a web browser as well from the Rhino command-line test runner.

### require(fileName, [{onload:function}])
When running from the command line, `require` becomes a Rhino call to `load`, but in a web browser, it dynamically creates a JavaScript `script` tag and loads the given file for you.  It takes an optional `onload` callback function that will be ran immediately after the given JavaScript file is loaded.  This helps you chain dependencies.  This is especially useful when running in-browser where each JavaScript file is loaded asynchronously in a separate thread.

    require("../../public/javascripts/prerequisite.js", {onload: function() {
        require("../../public/javascripts/dependent_file1.js");
        require("../../public/javascripts/dependent_file2.js");
    }});

### debug(message)
When running from the command line, `debug` simply prints a message to stdout, but in a web browser it outputs into the DOM directly.  This helps you avoid using the `print` function which prints to stdout in Rhino but actually opens a file print dialog when running in a browser!

### console.debug(message)
If you use Firebug, you might add a `console.debug` function call in your tests to debug a problem.  Calling this from the command-line would crash, however, because Firebug is missing.  To make life a little easier, this `console.debug` is just an alias to Rhino's `print` function and will write your message to stdout.

Extras
-------------

### rake js:fixtures
If you're on Mac OS X, this command opens your JavaScript fixtures directory using Finder to make running specs from a browser easy.  If you're running on Linux, it opens the fixtures directory using Firefox.

### rake js:shell
Runs an IRB-like JavaScript shell for debugging your JavaScript code.  jQuery and env.js are pre-loaded for you to make debugging DOM code easy.

    rake js:shell

    =================================================
     Rhino JavaScript Shell
     To exit type 'exit', 'quit', or 'quit()'.
    =================================================
     - loaded env.js
     - sample DOM loaded
     - jQuery-1.2.6 loaded
    =================================================
    Rhino 1.7 release 2 PRERELEASE 2008 07 28
    js> print("Hello World!")
    Hello World!
    js> 

Note that if you have `rlwrap` installed and on the command line path (and you really, really should!), then command-line history and readline arrow-up and down will be properly supported automatically.

Mocking Example with Smoke
--------------------------

...TBD....

Tips & Tricks
-------------
* Avoid using `print` in your tests while debugging.  It works fine from the command line but causes lots of headaches in browser.  (Just imagine a print dialog opening ten or fifteen times and then Firefox crashing... this is a mistake I've make too many times!  Trust me!)
* We don't recommend testing jQuery or Prototype, especially event wiring.  (You don't test Rails do you?)  Instead write a separate function, test it, and wire it to events using jQuery or Prototype.

Caveats
----------
env.js and jQuery 1.3.x do not currently get along well (as of 2009-04-14), so the JavaScript Testing Rails Plugin currently uses jQuery 1.2.6 to run command line specs.  This is currently in active development, and any help is very appreciated!

Contributing
------------
Fork the [Relevance repo on GitHub](http://www.github.com/relevance/javascript_testing) and start hacking!  If you have patches, send us pull requests.  Also, [env.js](http://github.com/thatcher/env-js), [Smoke](http://github.com/andykent/smoke), and [Screw.Unit](http://github.com/nkallen/screw-unit) could use your love too!

Links
-------------
* [JavaScript Testing Rails Plugin](http://github.com/relevance/javascript_testing)
* [Justin Gehtland's "Fully Headless JSSpec" Blog](http://blog.thinkrelevance.com/2008/7/31/fully-headless-jsspec)
* [Screw.Unit](http://github.com/nkallen/screw-unit)
* [Screw.Unit Mailing List](http://groups.google.com/group/screw-unit)
* [Smoke](http://github.com/andykent/smoke)
* [env.js](http://www.envjs.com) ([Github](http://github.com/thatcher/env-js))
* [env.js Mailing List](http://groups.google.com/group/envjs)
* [Mozilla Rhino](http://www.mozilla.org/rhino/)
* [W3C DOM Specifications](http://www.w3.org/DOM/DOMTR)

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
* Copyright &copy; 2008-2009 [Relevance, Inc.](http://www.thinkrelevance.com/), under the MIT license
* env.js     - Copyright 2007-2009 John Resig, under the MIT License
* Screw.Unit - Copyright 2008 Nick Kallen, license attached
* Rhino      - Copyright 2009 Mozilla Foundation, GPL 2.0
* Smoke      - Copyright 2008 Andy Kent, license attached

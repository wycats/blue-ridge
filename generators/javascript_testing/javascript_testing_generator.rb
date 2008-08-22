class JavascriptTestingGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'test/javascripts'
      m.file      'env.js',                         'test/javascripts/env.js'
      m.file      'config.js',                      'test/javascripts/config.js'
      m.file      'spec_application.js',            'test/javascripts/spec_application.js'

      m.directory 'test/javascripts/jsspec'
      m.file      'jsspec/index.html',               'test/javascripts/jsspec/index.html'
      m.file      'jsspec/jsspec.js',               'test/javascripts/jsspec/jsspec.js'
      m.file      'jsspec/prototypeForJsspec.js',   'test/javascripts/jsspec/prototypeForJsspec.js'
      m.file      'jsspec/consoleReportForRake.js', 'test/javascripts/jsspec/consoleReportForRake.js'

      m.directory 'test/javascripts/fixtures'
    end
  end

end

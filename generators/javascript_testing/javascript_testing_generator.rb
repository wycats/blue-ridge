class JavascriptTestingGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'test/javascript'
      m.file 'application_spec.js', 'test/javascript/application_spec.js'
      m.file 'spec_helper.js',      'test/javascript/spec_helper.js'
      
      m.directory 'test/javascript/fixtures'
      m.file 'application.html', 'test/javascript/fixtures/application.html'
      m.file 'screw.css',      'test/javascript/fixtures/screw.css'
    end
  end
end

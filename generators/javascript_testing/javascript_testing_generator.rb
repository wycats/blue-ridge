class JavascriptTestingGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'test/javascript'
      m.file      'spec_application.js', 'test/javascript/spec_application.js'
      m.directory 'test/javascript/fixtures'
    end
  end
end

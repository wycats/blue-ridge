$:.push File.join(File.dirname(__FILE__), "gems", "gems", "rack-0.9.1", "lib")
$:.push File.join(File.dirname(__FILE__), "gems", "gems", "rack-test-0.1.0", "lib")
$LOADED_FEATURES.push "rubygems.rb"

require "uri"
require "rack"
require "rack/test"

class TestRackApp
  def call(env)
    # if env["PATH_INFO"] == "/second"
    resp = Rack::Response.new
    resp.body = "omg"
    resp.to_a
  end
end

class Tester
  include Rack::Test::Methods
  
  def app
    TestRackApp.new
  end
  
  def fetch(xhr)
    path = URI.parse(xhr[:url]).path
    response = request(path)
    response
  end
end

$johnson.put("RackTester", Tester.new.method(:fetch))
$johnson.eval("__env__.mockConnection = {request: RackTester}")

$:.push File.join(File.dirname(__FILE__), "gems", "gems", "rack-0.9.1", "lib")
$:.push File.join(File.dirname(__FILE__), "gems", "gems", "rack-test-0.1.0", "lib")
$LOADED_FEATURES.push "rubygems.rb"

require "uri"
require "rack"
require "rack/test"

class App
  def self.call(env)
    resp = Rack::Response.new
    if File.file?("." + env["PATH_INFO"])
      return Rack::File.new(".").call(env)
    elsif env["PATH_INFO"] == "/second"
      resp.body = "omg"
      resp.headers["Content-Length"] = "3"
    end
    resp.to_a
  end
end

class Tester
  include Rack::Test::Methods
  
  def app
    App
  end
  
  def fetch(xhr)
    path = URI.parse(xhr[:url]).path
    response = request(path)
    response
  end
end

if $johnson
  $johnson.put("RackTester", Tester.new.method(:fetch))
  $johnson.eval("__env__.mockConnection = {request: RackTester}")
end
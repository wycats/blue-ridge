namespace :test do  
  desc "Runs all the JSSpec tests and collects the results"
  task :javascripts do
    plugin_prefix = "#{RAILS_ROOT}/vendor/plugins/javascript_testing"  
    test_runner_command = "java -jar #{plugin_prefix}/lib/js.jar #{plugin_prefix}/lib/test_runner.js"
    
    Dir.chdir("test/javascripts") do
      all_fine = true
      if ENV["TEST"]
        all_fine = false unless system("#{test_runner_command} #{ENV["TEST"]}")
      else
        Dir.glob("*_spec.js").each do |file|
          all_fine = false unless system("#{test_runner_command} #{file}")
        end
      end
      raise "JSSpec test failures" unless all_fine
    end
  end
  
  task :javascript => :javascripts
end

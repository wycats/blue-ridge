namespace :test do  
  desc "Runs all the JSSpec tests and collects the results"
  task :javascripts do
    plugin_prefix = "#{RAILS_ROOT}/vendor/plugins/javascript_testing"
    test_runner_command = "java -jar #{plugin_prefix}/lib/js.jar -w -debug #{plugin_prefix}/lib/test_runner.js"
    
    Dir.chdir("test/javascript") do
      all_fine = true
      if ENV["TEST"]
        all_fine = false unless system("#{test_runner_command} #{ENV["TEST"]}_spec.js")
      else
        Dir.glob("*_spec.js").each do |file|
          all_fine = false unless system("#{test_runner_command} #{file}")
        end
      end
      raise "Javascript test failures" unless all_fine
    end
  end
  
  
  task :javascript => :javascripts
end

namespace :js do
  task :fixtures do
    fixture_dir = "#{RAILS_ROOT}/test/javascript/fixtures"
    
    if PLATFORM['darwin']
      system("open #{fixture_dir}")
    elsif PLATFORM[/linux/]
      system("firefox #{fixture_dir}")
    else
      puts "You can run your in-browser fixtures from #{fixture_dir}."
    end
  end
  
end
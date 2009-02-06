plugin_prefix = "#{RAILS_ROOT}/vendor/plugins/javascript_testing"
fixture_dir = "#{RAILS_ROOT}/test/javascript/fixtures"
rhino_command = "java -jar #{plugin_prefix}/lib/js.jar -w -debug"
test_runner_command = "#{rhino_command} #{plugin_prefix}/lib/test_runner.js"

namespace :test do
  desc "Runs all the JavaScript tests and outputs the results"
  task :javascripts do
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
    if PLATFORM['darwin']
      system("open #{fixture_dir}")
    elsif PLATFORM[/linux/]
      system("firefox #{fixture_dir}")
    else
      puts "You can run your in-browser fixtures from #{fixture_dir}."
    end
  end
  
  task :shell do
    rlwrap = `which rlwrap`.chomp
    system("#{rlwrap} #{rhino_command} -f #{plugin_prefix}/lib/shell.js -f -")
  end
end
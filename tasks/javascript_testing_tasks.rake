namespace :test do  
  desc "Runs all the JSSpec tests and collects the results"
  task :javascript do
    Dir.chdir("test/javascripts") do
      all_fine = true
      if ENV["TEST"]
        all_fine = false unless system("java -jar #{RAILS_ROOT}/vendor/plugins/javascript_testing/lib/js.jar #{ENV["TEST"]}")
      else
        Dir.glob("spec*.js").each do |file|
          all_fine = false unless system("java -jar #{RAILS_ROOT}/vendor/plugins/javascript_testing/lib/js.jar #{file}")
        end
      end
      raise "JSSpec test failures" unless all_fine
    end
  end
end
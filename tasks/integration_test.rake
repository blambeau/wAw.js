# Installs a rake task for running unit tests on the coffee part.
begin
  desc "Run coffee tests"
  task :integration_test do |t|
    examples = File.expand_path('../../examples', __FILE__)
    Dir["#{examples}/*"].each{|folder|
      shell_safe_exec("cd #{folder} && rake")
    }
  end
ensure
  desc "integration"
  task :test => [:integration_test]
end


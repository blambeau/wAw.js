# Installs a rake task for running unit tests on the coffee part.
begin
  desc "Run coffee tests"
  task :coffee_test do |t|
    shell_safe_exec "cake test"
  end
ensure
  desc "coffee"
  task :test => [:coffee_test]
end


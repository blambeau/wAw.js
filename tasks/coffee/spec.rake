# Installs a rake task for running unit tests on the coffee part.
begin
  desc "Run coffee spec tests"
  task :"coffee:spec" do |t|
    shell_safe_exec "coffee spec/run_specs.coffee"
  end
ensure
  desc "coffee specs"
  task :test => [:"coffee:spec"]
  task :spec => [:"coffee:spec"]
end


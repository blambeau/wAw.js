# Installs a rake task for for running unit tests on the coffee part.
begin
  desc "Run coffee tests"
  task :js_test do |t|
    puts `cake test`
  end
ensure
  desc "Run all tests"
  task :test => [:js_test]
end


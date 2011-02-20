desc "Builds vendor/js/wawjs-#{$gemspec.version}.dev.js" 
task :"js:build" do
  wawjs  = File.expand_path("../../bin/wawjs", __FILE__)
  header = File.expand_path("../../LICENCE.js", __FILE__)
  target = File.expand_path("../../vendor/js/wawjs-#{$gemspec.version}.dev.js", __FILE__)
  src    = File.expand_path("../../src", __FILE__)
  cmd = "#{wawjs} compile --name=WawJS --header=#{header} --no-join --no-uglify #{src} > #{target}"
  shell_safe_exec(cmd)
end

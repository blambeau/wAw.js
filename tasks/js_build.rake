desc "Builds vendor/js/wawjs-#{$gemspec.version}.dev.js" 
task :"js:build" do
  nibjs  = File.expand_path("../../../nib.js/bin/nibjs", __FILE__)
  header = File.expand_path("../../LICENCE.js", __FILE__)
  target = File.expand_path("../../vendor/js/wawjs-#{$gemspec.version}.dev.js", __FILE__)
  src    = File.expand_path("../../src/wawjs", __FILE__)
  cmd = "#{nibjs} --libname=WawJS --coffee --no-uglify --autorequire --output=\"#{target}\" \"#{src}\""
  shell_safe_exec(cmd)
end

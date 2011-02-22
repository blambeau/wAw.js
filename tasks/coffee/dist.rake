desc "Builds vendor/js/wawjs-#{$gemspec.version}.dev.js" 
task :"coffee:dist" do
  nibjs  = _("../nib.js/bin/nibjs")
  header = _("LICENCE.js")
  src    = _("src/wawjs")

  # devel version
  target = _("vendor/js/wawjs-#{$gemspec.version}.dev.js")
  cmd = "#{nibjs} --libname=WawJS --coffee --coffee-compile --no-uglify --autorequire --header=\"#{header}\" --output=\"#{target}\" \"#{src}\""
  shell_safe_exec(cmd)

  # minimized version
  target = _("vendor/js/wawjs-#{$gemspec.version}.min.js")
  cmd = "#{nibjs} --libname=WawJS --coffee --coffee-compile --uglify --autorequire --header=\"#{header}\" --output=\"#{target}\" \"#{src}\""
  shell_safe_exec(cmd)
end

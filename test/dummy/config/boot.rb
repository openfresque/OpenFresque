# Determine where the dummy app’s Gemfile lives:
#  - locally: test/dummy/Gemfile → ../../../Gemfile relative to config/
#  - on Heroku: override via DUMMY_BUNDLE_GEMFILE
gemfile = ENV["DUMMY_BUNDLE_GEMFILE"] || File.expand_path("../../../Gemfile", __dir__)
ENV["BUNDLE_GEMFILE"] = gemfile

require "bundler/setup" if File.exist?(gemfile)

# Likewise, let you override where “lib” is at runtime:
lib_path = ENV["DUMMY_LIB_PATH"] || File.expand_path("../../../lib", __dir__)
$LOAD_PATH.unshift(lib_path) if Dir.exist?(lib_path)
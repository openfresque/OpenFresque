require_relative "lib/open_fresk/version"

Gem::Specification.new do |spec|
  spec.name          = "open_fresk"
  spec.version       = OpenFresk::VERSION
  spec.authors       = ["Vincent Daubry"]
  spec.email         = ["vdaubry@gmail.com"]
  spec.summary       = "Summary of OpenFresk."
  spec.description   = "Description of OpenFresk."
  spec.license       = "MIT"

  # Define which files should be packaged with the gem.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Production dependencies:
  spec.add_dependency "rails", "7.0.8.7"
  spec.add_dependency "puma"
  spec.add_dependency "pg"
  spec.add_dependency "sprockets-rails"
  spec.add_dependency "concurrent-ruby", '1.3.4'
end
require_relative "lib/open_fresk/version"

Gem::Specification.new do |spec|
  spec.name          = "open_fresk"
  spec.version       = OpenFresk::VERSION
  spec.authors       = ["Vincent Daubry"]
  spec.email         = ["vdaubry@gmail.com"]
  spec.summary       = "Summary of OpenFresk."
  spec.description   = "Description of OpenFresk."
  spec.license       = "MIT"

  # Define which files should be packaged with the gem (everything except path starting with test/, spec/, .git/ or tmp/)
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f|
      f.match(%r{\A(?:test|spec|\.git|tmp)/})
    }
  end
  spec.require_paths = ["lib"]

  # Production dependencies:
  spec.add_dependency "rails", "7.0.8.1"
  spec.add_dependency "puma"
  spec.add_dependency "pg"
  spec.add_dependency "sprockets-rails"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "concurrent-ruby", '1.3.4'
  spec.add_dependency "font_awesome5_rails", "1.5.0"
  spec.add_dependency "sass-rails", ">= 6"
  spec.add_dependency "bootstrap", "5.3.1"
  spec.add_dependency "redis", "4.6.0"
  spec.add_dependency "sidekiq", "6.5.12"
  spec.add_dependency "flatpickr"
end
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chrome_data/version'

Gem::Specification.new do |spec|
  spec.name          = "chrome_data"
  spec.version       = ChromeData::VERSION
  spec.authors       = ["Jim Ryan", "JC Grubbs", "Tony Coconate", "Cory Stephenson", "Zach Briggs"]
  spec.email         = ["jim@room118solutions.com", "jc@devmynd.com", "me@tonycoconate.com", "aevin@me.com", "briggszj@gmail.com"]
  spec.description   = %q{Provides a ruby interface for Chrome Data's API. Read more about it here: http://www.chromedata.com/}
  spec.summary       = %q{A ruby interface for Chrome Data's API}
  spec.homepage      = "http://github.com/room118solutions/chrome_data"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", '~> 1.10.0' # Locked at 1.10.x to prevent VCR warnings
  spec.add_development_dependency "mocha"

  spec.add_dependency "symboltable"
  spec.add_dependency "activesupport", '>= 4.0'
  spec.add_dependency "lolsoap", "~> 0.6.1"
end

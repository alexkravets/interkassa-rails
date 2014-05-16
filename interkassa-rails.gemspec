# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interkassa/version'

Gem::Specification.new do |spec|
  spec.name          = "interkassa-rails"
  spec.version       = Interkassa::VERSION
  spec.authors       = ["Alexander Kravets"]
  spec.email         = ["alex@slatestudio.com"]
  spec.description   = %q{Interkassa payment gateway integration}
  spec.summary       = %q{Interkassa payment gateway integration}
  spec.homepage      = "https://github.com/alexkravets/interkassa-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
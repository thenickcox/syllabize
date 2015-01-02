# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'syllabize/version'

Gem::Specification.new do |spec|
  spec.name          = "syllabize"
  spec.version       = Syllabize::VERSION
  spec.authors       = ["thenickcox"]
  spec.email         = ["nick@nickcox.me"]
  spec.description   = %q{A syllable counter written in Ruby}
  spec.summary       = %q{Syllabize counts the number of syllables in a gem}
  spec.homepage      = "http://github.com/thenickcox/syllabize"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.0"
  spec.add_development_dependency "numbers_and_words"
end

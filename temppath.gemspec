# -*- ruby -*-
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'temppath/version'

Gem::Specification.new do |gem|
  gem.name          = "temppath"
  gem.version       = Temppath::VERSION
  gem.authors       = ["Keita Yamaguchi"]
  gem.email         = ["keita.yamaguchi@gmail.com"]
  gem.description   = "temppath provides the method to create temporary path"
  gem.summary       = "temppath provides the method to create temporary path"
  gem.homepage      = "https://github.com/keita/temppath"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "uuidtools", "~> 2.1.3"
  gem.add_development_dependency "bacon", "~> 1.2.0"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"
  gem.add_development_dependency "rake"
end

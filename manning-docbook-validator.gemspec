# -*- encoding: utf-8 -*-
require File.expand_path('../lib/manning-docbook-validator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Bigg"]
  gem.email         = ["radarlistener@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "manning-docbook-validator"
  gem.require_paths = ["lib"]
  gem.version       = Manning::Docbook::Validator::VERSION

  gem.add_dependency 'nokogiri', '~> 1.5.5'
  gem.add_development_dependency 'rspec', '~> 2.10'

end

# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coy/version'

Gem::Specification.new do |gem|
  gem.name          = "coy"
  gem.version       = Coy::VERSION
  gem.authors       = ["Joel Helbling"]
  gem.email         = ["joel@joelhelbling.com"]
  gem.description   = %q{Protects sensitive file artifacts in a project, e.g. a yaml file with passwords in it.}
  gem.summary       = %q{Easily create AES-encrypted directories within a project to protect sensitive information.  Uses TrueCrypt (required to install) and uses Ignorance to prevent contents of protected directories from being inadvertently being added to a version control repository (Git, Hg, SVN).}
  gem.homepage      = "http://github.com/joelhelbling/coy"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'ignorance', '>= 0.0.1'
  gem.add_dependency 'highline', '~> 1.6.15'
  gem.add_dependency 'main', '~> 5.1.1'

  gem.add_development_dependency 'rspec',     '~> 2.12.0'
  gem.add_development_dependency 'fakefs',    '~> 0.4.2'
  gem.add_development_dependency 'cucumber',  '~> 1.2.1'
  gem.add_development_dependency 'aruba',     '~> 0.5.1'
  gem.add_development_dependency 'rake',      '~> 10.0.3'
end


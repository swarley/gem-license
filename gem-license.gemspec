# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'gem-license'
  spec.version       = '0.2.0'
  spec.authors       = ['Matt Carey']
  spec.email         = ['matthew.b.carey@gmail.com']

  spec.summary       = 'Gem plugin to download licenses'
  spec.description   = 'Gem plugin to download a LICENSE file based on its shortname'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'rubocop', '~> 0.69'
end

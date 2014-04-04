Gem::Specification.new do |s|
  s.name          = 'cafe_well_cli'
  s.version       = '0.0.0'
  s.date          = '2014-04-01'
  s.summary       = "A CLI interface to update your CafeWell health incentives."
  s.description   = "Allows you to enter activities, meals, stress breaks (etc) to receive\ncredit for CafeWell incentives."
  s.authors       = ["Brian Winterling"]
  s.email         = ''
  s.homepage      =
    'http://rubygems.org/gems/cafe_well_cli'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.bindir        = 'bin'

  s.add_runtime_dependency "mechanize"
  s.add_runtime_dependency "thor"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
end

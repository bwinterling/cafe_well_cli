Gem::Specification.new do |s|
  s.name          = 'cafe_well_cli'
  s.version       = '0.1.1'
  s.date          = '2014-04-01'
  s.summary       = "A CLI interface to update your CafeWell health incentives."
  s.description   = "Allows you to enter activities, meals, stress breaks (etc) to receive\ncredit for CafeWell incentives."
  s.authors       = ["Brian Winterling"]
  s.email         = 'bwinterling@users.noreply.github.com'
  s.homepage      =
    'http://github.com/bwinterling/cafe_well_cli'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.bindir        = 'bin'
  s.executables   << 'cafewell'

  s.add_runtime_dependency "mechanize", "~> 2.7"
  s.add_runtime_dependency "thor", "~> 0.19"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 10.2"
  s.add_development_dependency "pry", "~> 0.9"
end

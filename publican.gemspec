spec = Gem::Specification.new do |gem|
  gem.name = 'publican'
  gem.version = '1.0.0'
  gem.summary = 'Simple subscribe/publish library for your Ruby objects'
  gem.description = <<EOT
Simple subscribe/publish library for your Ruby objects.  Instead of returning symbols or raising custom-made exceptions,
let your callers know what happened in your method by publishing events.  You can choose whether these events can be
ignored or whether the caller must listen to them.
EOT
  gem.has_rdoc = false
  gem.author = "Roger Nesbitt"
  gem.email = "roger@seriousorange.com"
  gem.homepage = "http://github.com/mogest/publican"
  gem.license = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rake", "~> 10.1"
end

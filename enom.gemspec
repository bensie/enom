Gem::Specification.new do |s|
  s.name = "enom"
  s.version = "1.1.2"
  s.authors = ["James Miller"]
  s.summary = %q{Ruby wrapper for the Enom API}
  s.description = %q{Enom is a Ruby wrapper and command line interface for portions of the Enom domain reseller API.}
  s.homepage = "http://github.com/bensie/enom"
  s.email = "bensie@gmail.com"
  s.files  = %w( README.md Rakefile LICENSE ) + ["lib/enom.rb"] + Dir.glob("lib/enom/*.rb") + Dir.glob("lib/enom/commands/*.rb") + Dir.glob("test/**/*") + Dir.glob("bin/*")
  s.has_rdoc = false
  s.add_dependency "httparty", "~> 0.10.0"
  s.add_dependency "public_suffix", "~> 1.2.0"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "rake", "~> 0.9"
  s.executables = %w(enom)
  s.default_executable = "enom"
end

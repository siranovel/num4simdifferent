Gem::Specification.new do |s|
  s.name        = 'num4simdiff'
  s.version     = '0.3.1'
  s.date        = '2025-05-15'
  s.summary     = "num for simultaneous different"
  s.description = "numerical solution for simultaneous ordinaray differential equations"
  s.authors     = ["siranovel"]
  s.email       = "siranovel@gmail.com"
  s.homepage    = "http://github.com/siranovel/num4simdifferent"
  s.metadata    = {
      'changelog_uri'     => s.homepage + '/blob/main/CHANGELOG.md',
      'documentation_uri' => "https://rubydoc.info/gems/#{s.name}/#{s.version}",
      'homepage_uri'      => s.homepage,
      'wiki_uri'          => 'https://github.com/siranovel/mydocs/tree/main/num4simdifferent',
  }
  s.rdoc_options = ["--no-private"]
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.0"
  s.files       = ["LICENSE", "Gemfile", "CHANGELOG.md", ".yardopts"]
  s.files       += Dir.glob("{lib,ext}/**/*")
  s.extensions  = %w[ext/num4simdiff/Rakefile]
  s.add_dependency 'rake', '~> 13', '>= 13.0.6'
  s.add_development_dependency 'ffi-compiler', '~> 1.3', '>= 1.3.2'
end

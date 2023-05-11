Gem::Specification.new do |s|
  s.name        = 'num4simdiff'
  s.version     = '0.2.2'
  s.date        = '2023-05-11'
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
  s.files       = ["LICENSE", "Gemfile", "CHANGELOG.md", ".yardopts"]
  s.files       += Dir.glob("{lib,ext}/**/*")
  s.extensions  = %w[ext/num4simdiff/Rakefile]
  s.add_dependency 'ffi-compiler', '~> 1.0', '>= 1.0.1'
  s.add_development_dependency 'rake', '~> 12.3', '>= 12.3.3'
end

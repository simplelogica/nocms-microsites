$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "no_cms/microsites/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nocms-microsites"
  s.version     = NoCms::Microsites::VERSION
  s.authors     = ["zapic0"]
  s.email       = ["fernando.zapico@the-cocktail.com"]
  s.homepage    = "https://github.com/simplelogica/nocms-microsites"
  s.summary     = "Gem to add NoCMS support for many domains sharing the same routes or with sub-sets of them"
  s.description = "This engine allows NoCMS to have many domains for the same app sharing routes from a different root (www.example.com/myexample available too on www.myexample.com/)"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 4.2", "< 5.1"
  s.add_dependency 'config', '~> 1.0.0'
  s.add_dependency "globalize", '>= 4.0.0', '< 5.2'

  s.add_development_dependency "sqlite3"
end

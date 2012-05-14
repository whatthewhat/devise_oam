$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_oam/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise-oam"
  s.version     = DeviseOam::VERSION
  s.authors     = ["Mikhail Topolskiy"]
  s.email       = ["mikhail.topolskiy@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "OAM authentication strategy for devise."
  s.description = "Authentication strategy for devise based on headers, passed by Oracle Access Manager."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.0"
  s.add_dependency "devise", ">= 2.0"

  s.add_development_dependency "sqlite3"
end

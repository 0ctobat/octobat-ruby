$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'octobat/version'

spec = Gem::Specification.new do |s|
  s.name = 'octobat'
  s.version = Octobat::VERSION
  s.summary = 'Ruby bindings for the Octobat API'
  s.description = 'Octobat is the easiest way to generate invoices online. See https://www.octobat.com for details.'
  s.authors = ['Gaultier Laperche']
  s.email = ['gaultier@octobat.com']
  s.homepage = 'https://www.octobat.com/api'
  s.license = 'MIT'

  s.add_dependency('rest-client', '>= 1.4', '< 4.0')
  #s.add_dependency('mime-types', '>= 1.25', '< 3.0')
  s.add_dependency('json', '~> 1.8.1')

  #s.add_development_dependency('mocha', '~> 0.13.2')
  #s.add_development_dependency('shoulda', '~> 3.4.0')
  #s.add_development_dependency('test-unit')
  #s.add_development_dependency('rake')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end

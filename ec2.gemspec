# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)
require 'ec2/version'

Gem::Specification.new do |s|
  s.name        = 'ec2'
  s.version     = EC2::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Samuel Garneau']
  s.email       = ['sam@garno.me']
  s.homepage    = 'http://github.com/garno/ec2'
  s.summary     = 'Manage EC2 instances like a god'
  s.description = 'Manage your EC2 instances with POO magic. Everything you need to scale up.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'addressable'
  s.add_dependency 'hpricot'
  s.add_dependency 'nokogiri'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'rspec',        '~> 2.11'
  s.add_development_dependency 'mocha',        '~> 0.12'
  s.add_development_dependency 'guard',        '~> 1.2'
  s.add_development_dependency 'guard-rspec',  '~> 1.2'
  s.add_development_dependency 'yard',         '~> 0.8'
  s.add_development_dependency 'redcarpet',    '~> 2.1'
  s.add_development_dependency 'rake'

end


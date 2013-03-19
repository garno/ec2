$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'ec2'
require 'rspec'
require 'mocha_standalone'

RSpec.configure do |c|
end

def load_xml(*file)
  JSON.parse(Hash.from_xml(File.open(File.join(File.expand_path(File.dirname(__FILE__)), "mocks", "#{file.join('/')}.xml"))).to_json, :symbolize_names => true)
end

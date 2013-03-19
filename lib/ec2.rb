# => Require
require 'addressable/uri'
require 'hpricot'
require 'nokogiri'
require 'date'

# => Base
require 'ec2/version'

# => Helpers
require 'ec2/helpers/query'
require 'ec2/helpers/console'
require 'ec2/helpers/hash'
require 'ec2/helpers/string'
require 'ec2/helpers/exceptions'

# => Models
require 'ec2/models/instance'
require 'ec2/models/request'
require 'ec2/models/keypair'
require 'ec2/models/elastic_ip'

module EC2; end

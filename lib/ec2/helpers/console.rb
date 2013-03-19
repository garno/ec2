def reload!
  # Silence warning
  verbosity = $VERBOSE
  $VERBOSE = nil

    # => Base
    load 'ec2.rb'
    load 'ec2/version.rb'

    # => Helpers
    load 'ec2/helpers/query.rb'
    load 'ec2/helpers/console.rb'
    load 'ec2/helpers/string.rb'
    load 'ec2/helpers/hash.rb'
    load 'ec2/helpers/exceptions.rb'

    # => Models
    load 'ec2/models/instance.rb'
    load 'ec2/models/request.rb'
    load 'ec2/models/keypair.rb'
    load 'ec2/models/elastic_ip.rb'

  $VERBOSE = verbosity

  true
end

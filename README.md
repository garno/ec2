# EC2

EC2 allows you to control your EC2 instances with ease. Btw, this is a completly stupid name. Find something else and quick. __Thank you.__

## Warning

This is a work in progress (or at least was...). It might not be a good idea to use it for production and real server handling.

## Usage

Here's a short example of what can be done. The complete API is documented [here](https://github.com/garno/ec2/wiki).

	# Play with an instance
    instance = EC2::Instances.find('i-1ac3f167')
    
    instance.restart
    # => true
    
    instance.tags = {
      'Name' => 'app-prod-1',
      'Environment' => 'production'
    }
    # => true
    
    # Stop all instances
    EC2::Instances.all.each(&:stop)
    
    # Create and associate an Elastic IP
    ip = EC2::ElasticIP.create
    
    ip.associate_with(instance)
    # => true

## Licence

© under the MIT license. Read the license [here](https://github.com/garno/ec2/blob/master/LICENSE).

module EC2
  class ElasticIP

    # => Class Methods

      @@mapping = {
        :instanceId     => :instance_id,
        :publicIp       => :public_ip
      }

      attr_accessor :data

      # Get a single elastic ip
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeAddresses.html
      # @param [String] ip ip address
      # @return [Nil] if ip isn't found
      # @return [EC2::ElasticIP] if ip is found
      def self.find(ip) # {{{
        d = EC2::Helpers::Query.get('DescribeAddresses', {'PublicIp.1' => ip})

        ElasticIP.new(d[:DescribeAddressesResponse][:addressesSet][:item])
      end # }}}

      # Get all elastic ips
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeAddresses.html
      # @return [Array<EC2::ElasticIP>] array of ips
      def self.all # {{{
        d = EC2::Helpers::Query.get('DescribeAddresses')

        d[:DescribeAddressesResponse][:addressesSet][:item].map do |address|
          ElasticIP.new(address)
        end
      end # }}}

      # Allocate a new elastic ip
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-AllocateAddress.html
      # @return [EC2::ElasticIP] the new allocated elastic ip
      def self.create # {{{
        d = EC2::Helpers::Query.get('AllocateAddress')

        self.new(d[:AllocateAddressResponse])
      end # }}}

    # => Instance methods

      # Initialize a new instance object
      #
      # @param [Hash] data instance item
      # @return [Bool] success
      def initialize(data) # {{{
        @data = {}
        data.each do |k, v|
          @data.merge! @@mapping[k] ? {@@mapping[k] => v} : {k => v}
        end

        true
      end # }}}

      # Return value for mapped attributes if available
      def method_missing(method, *args) # {{{
        return @data[method.to_sym] if @data[method.to_sym]
      end # }}}

      # Release address
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-ReleaseAddress.html
      # @return [Boolean] true
      def release # {{{
        delete
      end # }}}
      def delete # {{{
        EC2::Helpers::Query.get('ReleaseAddress', {'PublicIp' => self.public_ip})

        true
      end # }}}

      # Associate elastic ip to an instance
      #
      # @param [EC2::Instance|String] Instance object or ID
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-AssociateAddress.html
      # @return [Boolean] true
      def associate_to(instance) # {{{
        EC2::Helpers::Query.get('AssociateAddress', {
          'PublicIp'   => self.public_ip,
          'InstanceId' => instance.id
        })
        @data[:instance_id] = instance.id

        true
      end # }}}

      # Dissociate elastic ip from an instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DisassociateAddress.html
      # @return [Boolean] true
      def dissociate # {{{
        EC2::Helpers::Query.get('DisassociateAddress', {'PublicIp' => self.public_ip})
        @data[:instance_id] = nil

        true
      end # }}}

      # Instance associated with the ip
      #
      # @return [EC2::Instance] associated instance
      def instance # {{{
        return EC2::Instance.find(self.instance_id) if self.instance_id
        nil
      end # }}}

  end
end

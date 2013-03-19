module EC2
  class KeyPair

    # => Class Methods

      @@mapping = {
       :keyName        => :name,
       :keyFingerprint => :fingerprint,
       :keyMaterial    => :material
      }

      attr_accessor :data

      # Get all keypair
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeKeyPairs.html
      # @return [Array<EC2::KeyPair>] array of keypairs
      def self.all # {{{
        d = EC2::Helpers::Query.get('DescribeKeyPairs')
        d[:DescribeKeyPairsResponse][:keySet][:item].map { |k| KeyPair.new(k) }
      end # }}}

      # Create a keypair
      #
      # @TODO:
      #   - Handle InvalidKeyName.Duplicate error when creating an existing key pair
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CreateKeyPair.html
      # @return [EC2::KeyPair] the new keypair
      def self.create(name) # {{{
        d = EC2::Helpers::Query.get('CreateKeyPair', {'KeyName' => name})

        KeyPair.new(d[:CreateKeyPairResponse])
      end # }}}

    # => Instance methods

      # Initialize a new instance object
      #
      # @param [Hash] data instance item
      # @return [Bool] success
      def initialize(data={}) # {{{
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

      # Set the name
      #
      # @param [String] name
      def name=(name) # {{{
        @data[:name] = name
      end # }}}

      # Create the key
      def create # {{{
        self.data = KeyPair.create(self.name).data
      end # }}}

      # Delete the key
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteKeyPair.html
      # @return [Bool] success
      def delete # {{{
        EC2::Helpers::Query.get('DeleteKeyPair', {'KeyName' => self.name})
        true
      end # }}}

  end
end

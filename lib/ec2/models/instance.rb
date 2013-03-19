require 'ec2/models/instance/actions'

module EC2
  class Instance
    include EC2::Instance::Actions

    # => Attributes

      @@mapping = {
        :imageId          => :image_id,
        :instanceId       => :id,
        :privateDnsName   => :private_dns,
        :dnsName          => :public_dns,
        :keyName          => :key_name,
        :instanceType     => :instance_type,
        :groupId          => :group_id,
        :groupName        => :group_name,
        :privateIpAddress => :private_ip,
        :ipAddress        => :ip
      }

      attr_accessor :data

    # => Class Methods

      # Get a single instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeInstances.html
      # @param [String] instance id
      # @return [Nil] if instance isn't found
      # @return [EC2::Instance] if instance is found
      def self.find(id) # {{{
        d = EC2::Helpers::Query.get('DescribeInstances', {'InstanceId.1' => id})

        reservation_set = d[:DescribeInstancesResponse][:reservationSet][:item]

        attributes = reservation_set[:instancesSet][:item]
        attributes.merge! reservation_set[:groupSet][:item] rescue({})

        Instance.new(attributes)
      end # }}}

      # Get all instances
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeInstances.html
      # @return [Array<EC2::Instance>] array of instances
      def self.all # {{{
        instances = []

        d = EC2::Helpers::Query.get('DescribeInstances')

        reservation_sets = d[:DescribeInstancesResponse][:reservationSet]

        return [] if reservation_sets.blank?
        case reservation_sets[:item]
        when Hash
          instances << Instance.new(reservation_sets[:item][:instancesSet][:item].merge(
            reservation_sets[:item][:groupSet][:item]
          ))
        when Array
          reservation_sets[:item].each do |reservation|
            instances << Instance.new(reservation[:instancesSet][:item].merge(
              reservation[:groupSet][:item]
            ))
          end
        end

        instances
      end # }}}

      # Launch instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-RunInstances.html
      # @param [Hash] args
      # @example
      #   EC2::Instance.run {
      #     :image_id => 'ami-31814f58',
      #     :instance_type => 'm1.small',
      #     :max_count => 1,
      #     :min_count => 1
      #   }
      #   # => EC2::Instance
      # @raise [RequiredArgumentsMissing] if required arguments are missing
      # @raise [CannotLaunchInstances] if instances cannot be launched
      # @return [EC2::Instance] the newly created instance
      def self.run(args) # {{{
        # Handling Amazon parameters edge case
        #
        ## Security Groups
        if args[:security_groups]
          args[:security_groups].each_with_index do |group, i|
            args.merge! "security_group.#{i + 1}" => group
          end
          args.delete(:security_groups)
        end

        d = EC2::Helpers::Query.get('RunInstances', args.camel_case_keys)

        if !args.include?(:min_count) or args[:min_count] == '1'
          return EC2::Instance.new(d[:RunInstancesResponse][:instancesSet][:item])
        end

        d[:RunInstancesResponse][:instancesSet][:item].map do |instance|
          EC2::Instance.new(instance)
        end
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

      # Get instance state
      #
      # @return [Array] \[code, state\]
      def status(args={}) # {{{
        if args[:force_refresh] == true
          instance = Instance.find(self.id)
          @data.merge! :instanceState => instance.status
        end

        @data[:instanceState].flatten.delete_if{|v| v.is_a? Symbol}
      end # }}}

      # Get launch date
      #
      # @return [DateTime] launched_at
      def launched_at # {{{
        DateTime.parse(@data[:launchTime])
      end # }}}

  end
end

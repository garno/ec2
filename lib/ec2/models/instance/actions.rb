module EC2
  class Instance
    module Actions

      # Start instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-StartInstances.html
      # @raise [InstanceCannotBeStarted] if the instance can't be started
      # @return [EC2::Request] the request object
      def start # {{{
        d = EC2::Helpers::Query.get('StartInstances', {'InstanceId.1' => self.id})
        @data[:instanceState] = d[:StartInstancesResponse][:instancesSet][:item][:currentState]

        true
      end # }}}

      # Stop instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-StopInstances.html
      # @raise [InstanceCannotBeRestarted] if the instance can't be restarted
      # @return [Boolean] true
      def stop # {{{
        d = EC2::Helpers::Query.get('StopInstances', {'InstanceId.1' => self.id})
        @data[:instanceState] = d[:StopInstancesResponse][:instancesSet][:item][:currentState]

        true
      end # }}}

      # Terminate instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-TerminateInstances.html
      # @raise [OperationNotPermitted] if termination protection is on
      # @return [Boolean] true
      def terminate # {{{
        d = EC2::Helpers::Query.get('TerminateInstances', {'InstanceId.1' => self.id})

        @data[:instanceState] = d[:TerminateInstancesResponse][:instancesSet][:item][:currentState]

        true
      end # }}}

      # Restart instance
      #
      # @see http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-RebootInstances.html
      # @return [Boolean] true
      def restart # {{{
        EC2::Helpers::Query.get('RebootInstances', {'InstanceId.1' => self.id})

        true
      end # }}}

    end
  end
end

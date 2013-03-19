module EC2
  module Helpers
    module Query

      require 'base64'
      require 'cgi'
      require 'openssl'
      require 'digest/sha1'
      require 'net/https'
      require 'net/http'
      require 'time'
      require 'json'
      require 'active_support/core_ext'

      # Make a GET query to Amazon EC2 API
      #
      # @param [String] action the API action to execute
      # @param [Hash] parameters query parameters
      # @response [String] response body
      def self.get(action, parameters={}) # {{{
        parameters.merge! 'Action' => action
        res = Net::HTTP.start('ec2.us-east-1.amazonaws.com') do |http|
          http.get("/?#{generate_query_string('GET', 'ec2.us-east-1.amazonaws.com', parameters)}")
        end

        json_response = JSON.parse(Hash.from_xml(res.body).to_json, :symbolize_names => true)
        raise_errors json_response

        json_response
      end # }}}

      # Turns parameters hash into a canonicalized query string
      #
      # @param [Hash] parameters
      # @return [String] query string
      def self.canonicalized_query_string(parameters) # {{{
        parameters.merge!({
          'AWSAccessKeyId'   => 'AMAZON_AWS_KEY',
          'SignatureMethod'  => 'HmacSHA256',
          'SignatureVersion' => '2',
          'Version'          => '2012-08-15',
          'Expires'          => Time.at(Time.now.to_i + 60).getutc.iso8601
        })
        parameters = parameters.each_pair { |k,v| {URI.escape(k) => URI.escape(v)} }
        query_string = Addressable::URI.new
        query_string.query_values = Hash[parameters.sort]
        query_string.query
      end # }}}

      # Generate the string to sign
      #
      # @param [String] verb the http verb [GET|POST]
      # @param [String] endpoint the API endpoint
      # @param [String] query_string the canonicalized_query_string
      # @return [String] the string to sign
      def self.generate_string_to_sign(verb, endpoint, query_string) # {{{
        string = "#{verb.upcase}\n"
        string << "#{endpoint}\n"
        string << "/\n"
        string << "#{query_string}"
        string
      end # }}}

      # Generate query_string with the signature
      #
      # @param [String] verb the http verb [GET|POST]
      # @param [String] endpoint the API endpoint
      # @param [String] query_string the canonicalized_query_string
      # @return [String] the signed query_string
      def self.generate_query_string(verb, endpoint, parameters) # {{{
        query_string = canonicalized_query_string(parameters)
        string_to_sign = generate_string_to_sign(verb, endpoint, query_string)

        digest = OpenSSL::Digest::Digest.new('sha256')
        signature = Base64.encode64(OpenSSL::HMAC.digest(digest, 'BI2xIb0shvpTd0ZxinCwlTP70iqKbLmIhX1g1GFp', string_to_sign)).gsub("\n","")

        query_string << "&Signature=#{signature}"
      end # }}}

      # Raise exception if required
      #
      # @param [Hash] d request data in a symbolized hash
      # @return [Boolean] false if no error is raised
      def self.raise_errors(d) # {{{
        if d[:Response] and d[:Response][:Errors]
          raise Object.const_get(d[:Response][:Errors][:Error][:Code].gsub('.', '')), d[:Response][:Errors][:Error][:Message]
        end

        false
      end # }}}

    end
  end
end

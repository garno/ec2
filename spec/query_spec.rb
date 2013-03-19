# encoding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe EC2::Helpers::Query do
  context 'do a GET query' do
    # it 'should canonicalized query string and append required parameters' do # {{{
    #   query_string = EC2::Helpers::Query.canonicalized_query_string({
    #     'InstanceId.1'    => 'first-instance-id',
    #     'InstanceId.2'    => 'second-instance-id',
    #     'Filter.1.Name'   => 'instance-type',
    #     'Filter.1.Value'  => 'm1.small',
    #     'InexistantParam' => 'to test spaces'
    #   })
    #   query_string.should eq("AWSAccessKeyId=AKIAJBLN7JNJYVZDH4ZA&Filter.1.Name=instance-type&Filter.1.Value=m1.small&InexistantParam=to%20test%20spaces&InstanceId.1=first-instance-id&InstanceId.2=second-instance-id&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=#{CGI.escape(Time.now.getutc.iso8601)}&Version=2012-08-15")
    # end # }}}

    # it 'should generate a signature string before generating signature' do # {{{
    #   string_to_sign = EC2::Helpers::Query.generate_string_to_sign("GET", "ec2.us-east-1.amazonaws.com", EC2::Helpers::Query.canonicalized_query_string({
    #     'InstanceId.1'    => 'first-instance-id'
    #   }))

    #   string_to_sign.should eq("GET\nec2.us-east-1.amazonaws.com\n/\nAWSAccessKeyId=AKIAJBLN7JNJYVZDH4ZA&InstanceId.1=first-instance-id&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=#{CGI.escape(Time.now.getutc.iso8601)}&Version=2012-08-15")
    # end # }}}

    # it 'should sign request' do # {{{
    #   query_string = EC2::Helpers::Query.generate_query_string("GET", "ec2.us-east-1.amazonaws.com", {
    #     'InstanceId.1'    => 'first-instance-id'
    #   })
    #   pending "Need to figure out how to fake the Timestamp"
    # end # }}}
  end
end

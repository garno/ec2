# encoding: utf-8
require File.join(File.dirname(__FILE__), '../spec_helper.rb')

describe EC2::Instance::Actions do # {{{

  context 'stop' do # {{{
    subject do # {{{
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'single-find-stopped'))
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'single-find'))
      EC2::Helpers::Query.expects(:get)
        .with('StopInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'actions', 'stop'))
      EC2::Instance.find('i-bb726fc7')
    end # }}}

    it 'should be stoppable' do # {{{
      subject.stop.should be_true
    end # }}}

    it 'should update object status' do # {{{
      subject.status.should eq(['16', 'running'])
      subject.stop
      subject.status.should eq(['64', 'stopping'])
      subject.status(:force_refresh => true).should eq(['80', 'stopped'])
    end # }}}
  end # }}}

  context 'start' do # {{{
    subject do # {{{
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'single-find'))
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'single-find-stopped'))
      EC2::Helpers::Query.expects(:get)
        .with('StartInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'actions', 'start'))
      EC2::Instance.find('i-bb726fc7')
    end # }}}

    it 'should be startable' do # {{{
      subject.start.should be_true
    end # }}}

    it 'should update object status' do # {{{
      subject.status.should eq(['80', 'stopped'])
      subject.start
      subject.status.should eq(['0', 'pending'])

      subject.status(:force_refresh => true).should eq(['16', 'running'])
    end # }}}
  end # }}}

end # }}}

describe EC2::Instance, '#all' do # {{{

    context 'no instance' do
      subject do # {{{
        EC2::Helpers::Query.expects(:get)
          .with('DescribeInstances')
          .returns(load_xml('instances', 'all-no-instance'))
        EC2::Instance.all
      end # }}}

      it 'should return an empty array' do # {{{
        subject.is_a?(Array).should be_true
        subject.count.should eq(0)
      end # }}}
    end

    context 'only one instance' do
      subject do # {{{
        EC2::Helpers::Query.expects(:get)
          .with('DescribeInstances')
          .returns(load_xml('instances', 'all-one-instance'))
        EC2::Instance.all
      end # }}}

      it 'should return an array with a single EC2::Instance object' do # {{{
        subject.count.should eq(1)
      end # }}}
    end

    context 'more than one instance' do
      subject do # {{{
        EC2::Helpers::Query.expects(:get)
          .with('DescribeInstances')
          .returns(load_xml('instances', 'all-more-than-one'))
        EC2::Instance.all
      end # }}}

      it 'should return an array of EC2::Instance objects' do # {{{
        subject.count.should eq(2)
        subject.first.is_a?(EC2::Instance).should be_true
      end # }}}
    end


end # }}}

describe EC2::Instance, '#find' do # {{{

  context 'with a known ID' do # {{{
    subject do # {{{
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc7'})
        .returns(load_xml('instances', 'single-find'))
      EC2::Instance.find('i-bb726fc7')
    end # }}}

    its(:class)         { should eq(EC2::Instance) }
    its(:id)            { should eq('i-bb726fc7') }
    its(:image_id)      { should eq('ami-1624987f') }
    its(:private_ip)    { should eq('10.248.233.40') }
    its(:instance_type) { should eq('t1.micro') }
    its(:ip)            { should eq('23.22.178.248') }
    its(:public_dns)    { should eq('ec2-23-22-178-248.compute-1.amazonaws.com') }
    its(:private_dns)   { should eq('domU-12-31-39-02-E6-DE.compute-1.internal') }
    its(:status)        { should eq(['16', 'running']) }
    its(:key_name)      { should eq('SamY') }
    its(:launched_at)   { should eq(DateTime.parse('2012-11-09T04:17:48.000Z')) }
  end # }}}

  context 'with an unknown ID' do # {{{
    subject do # {{{
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc8'})
        .raises(EC2::Helpers::Query.raise_errors(load_xml('instances', 'instance-not-found')))
      EC2::Instance.find('i-bb726fc8')
    end # }}}

    it 'should return a InvalidInstanceIDNotFound exception' do # {{{
      expect{ subject }.to raise_error(InvalidInstanceIDNotFound)
    end # }}}
  end # }}}

  context 'with a malformed ID' do # {{{
    subject do # {{{
      EC2::Helpers::Query.expects(:get)
        .with('DescribeInstances', {'InstanceId.1' => 'i-bb726fc8'})
        .raises(EC2::Helpers::Query.raise_errors(load_xml('instances', 'malformed-id')))
      EC2::Instance.find('malformed-id')
    end # }}}

    it 'should raise a InvalidInstanceIDMalformed exception' do # {{{
      expect{ subject }.to raise_error(InvalidInstanceIDMalformed)
    end # }}}
  end # }}}

end # }}}

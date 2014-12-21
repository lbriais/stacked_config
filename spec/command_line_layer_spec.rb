require 'spec_helper'


describe StackedConfig::Layers::CommandLineLayer do
  subject { StackedConfig::Layers::CommandLineLayer.new }

  it 'should have some default command line options defined' do
    expect(subject.length > 0).to be_truthy
  end

end
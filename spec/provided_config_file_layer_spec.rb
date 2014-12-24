require 'spec_helper'


describe StackedConfig::Layers::ProvidedConfigFileLayer do

  subject { StackedConfig::Layers::ProvidedConfigFileLayer.new }


  it 'should be empty by default' do
    expect(subject.empty?).to be_truthy
  end



end
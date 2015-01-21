require 'spec_helper'

describe StackedConfig::Layers::EnvLayer do

  before(:all) do
    (1..3).each { |i|
      ENV["StackedConfig::Layers::EnvLayer::VAR#{i}"] = "VALUE#{i}"
    }
  end

  after(:all) do
    (1..3).each { |i|
      ENV.delete("StackedConfig::Layers::EnvLayer::VAR#{i}")
    }
  end

  it 'should get all ENV values without any filter' do
    layer = StackedConfig::Layers::EnvLayer.new
    layer.load

    expect(layer.to_a).to eq(ENV.to_hash.to_a)
    expect(layer.name).to eq('ENV layer')
  end


  it 'should get filtered values by list of accepted values from ENV' do
    layer = StackedConfig::Layers::EnvLayer.new(['StackedConfig::Layers::EnvLayer::VAR1', 'StackedConfig::Layers::EnvLayer::VAR3'])
    layer.load
    expect(layer.length).to eq 2
    [1,3].each { |i|
      expect(layer["StackedConfig::Layers::EnvLayer::VAR#{i}"]).to eql("VALUE#{i}")
    }
  end


  it 'should get filtered values by regexp from ENV' do
    layer = StackedConfig::Layers::EnvLayer.new(/StackedConfig::Layers::EnvLayer::VAR[13]/)
    layer.load
    expect(layer.length).to eq 2
    [1,3].each { |i|
      expect(layer["StackedConfig::Layers::EnvLayer::VAR#{i}"]).to eq("VALUE#{i}")
    }
  end

end
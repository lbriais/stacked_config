require 'spec_helper'

describe StackedConfig::Layers::EnvLayer do

  NIL_FILTER = nil
  STRING_FILTER ='StackedConfig::Layers::EnvLayer::VAR1'
  ARRAY_FILTER = %w(StackedConfig::Layers::EnvLayer::VAR1 StackedConfig::Layers::EnvLayer::VAR3)
  REGEXP_FILTER = /StackedConfig::Layers::EnvLayer::VAR[13]/

  before(:all) do
    (1..3).each { |i| ENV["StackedConfig::Layers::EnvLayer::VAR#{i}"] = "VALUE#{i}" }
  end

  after(:all) do
    (1..3).each { |i| ENV.delete("StackedConfig::Layers::EnvLayer::VAR#{i}") }
  end

  context 'when no filter is provided' do

    it 'should contain all ENV values' do
      layer = StackedConfig::Layers::EnvLayer.new
      expect(layer.to_a).to eq(ENV.to_hash.to_a)
      layer = StackedConfig::Layers::EnvLayer.new NIL_FILTER
      expect(layer.to_a).to eq(ENV.to_hash.to_a)
    end

  end

  context 'when a filter is provided' do

    [ARRAY_FILTER, REGEXP_FILTER].each do |filter|

      it "should contain filtered ENV variables according to the #{filter.class} filter" do
        layer = StackedConfig::Layers::EnvLayer.new(filter)
        [1,3].each { |i|
          expect(layer["StackedConfig::Layers::EnvLayer::VAR#{i}"]).to eql("VALUE#{i}")
        }
        expect(layer.keys.length == 2).to be_truthy
      end

    end

    it 'should filter according a String if only one value is requested' do
      layer = StackedConfig::Layers::EnvLayer.new(STRING_FILTER)
      expect(layer['StackedConfig::Layers::EnvLayer::VAR1']).to eql 'VALUE1'
      expect(layer.keys.length == 1).to be_truthy
    end

    [NIL_FILTER, STRING_FILTER, ARRAY_FILTER, REGEXP_FILTER].each do |filter|
      it "should be the same to provide a #{filter.class} filter to the constructor or afterwards" do
        layer1 = StackedConfig::Layers::EnvLayer.new(filter)
        layer2 = StackedConfig::Layers::EnvLayer.new
        layer2.filter = filter
        expect(layer1).to eq layer2
      end
    end

  end

end

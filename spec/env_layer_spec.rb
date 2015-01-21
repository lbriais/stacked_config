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
      layer.load
      expect(layer.to_a).to eq(ENV.to_hash.to_a)
      layer = StackedConfig::Layers::EnvLayer.new NIL_FILTER
      layer.load
      expect(layer.to_a).to eq(ENV.to_hash.to_a)
    end

  end

  context 'when a filter is provided' do

    [ARRAY_FILTER, REGEXP_FILTER].each do |filter|

      it "should contain filtered ENV variables according to the #{filter.class} filter" do
        layer = StackedConfig::Layers::EnvLayer.new(filter)
        layer.load
        [1,3].each { |i|
          expect(layer["StackedConfig::Layers::EnvLayer::VAR#{i}"]).to eql("VALUE#{i}")
        }
        expect(layer.keys.length == 2).to be_truthy
      end

    end

    it 'should filter according a String if only value is requested' do
      layer = StackedConfig::Layers::EnvLayer.new(STRING_FILTER)
      layer.load
      expect(layer['StackedConfig::Layers::EnvLayer::VAR1']).to eql 'VALUE1'
      expect(layer.keys.length == 1).to be_truthy
    end

  end

end
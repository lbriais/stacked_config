require 'spec_helper'


describe StackedConfig::Layers::CommandLineLayer do
  subject { StackedConfig::Layers::CommandLineLayer.new }

  it 'should have some default command line options defined' do
    expect(subject.length > 0).to be_truthy
  end

  it 'should have a "help" command line options defined' do
    expect(subject.keys.include? :help).to be_truthy
  end

  it 'should have a "auto" command line options defined' do
    expect(subject.keys.include? :auto).to be_truthy
  end

  it 'should have a "simulate" command line options defined' do
    expect(subject.keys.include? :simulate).to be_truthy
  end

  it 'should have a "verbose" command line options defined' do
    expect(subject.keys.include? :verbose).to be_truthy
  end


end
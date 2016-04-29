require 'spec_helper'


describe StackedConfig::Layers::CommandLineLayer do
  subject { StackedConfig::Layers::CommandLineLayer.new }

  it 'should expose an empty layer by default' do
    expect(subject.length == 0).to be_truthy
  end

  it 'should have a "help" command line options defined' do
    expect(subject.possible_options.include? :help).to be_truthy
  end

  it 'should have a "auto" command line options defined' do
    expect(subject.possible_options.include? :auto).to be_truthy
  end

  it 'should have a "simulate" command line options defined' do
    expect(subject.possible_options.include? :simulate).to be_truthy
  end

  it 'should have a "verbose" command line options defined' do
    expect(subject.possible_options.include? :verbose).to be_truthy
  end

  context 'when command line parameter are passed' do
    before(:all) {
      ARGV.replace ['--help']
    }

    it 'should end-up as a value in the layer' do
      subject.reload
      expect(subject.length).not_to be 0
      expect(subject['help']).to be_truthy
    end

  end

  context 'when extra command line parameter are passed (not part of a defined option)' do
    let(:extra_options)  {%w(extra1 extra2) }
    let(:options) { %w(--help  --verbose) + extra_options }

    it 'should provide the extra options while leaving ARGV untouched' do
      ARGV.replace options
      subject.reload
      expect(subject.extra_parameters).to eq extra_options
      expect(ARGV).to eq options

    end
  end



end
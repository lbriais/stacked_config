require 'spec_helper'


describe 'Using stacked_config within a gem' do

	it 'should detect we are in a gem' do
		expect(StackedConfig::SourceHelper.executable_gem_config_root).to_not be_nil
		expect(StackedConfig::SourceHelper.executable_gem_config_root =~ /rspec-core/).to be_truthy
	end

end
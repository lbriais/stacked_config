require 'spec_helper'


describe 'Using stacked_config within a gem' do

	it 'should detect we are in a gem' do
		expect(StackedConfig::SourceHelper.gem_config_root).to_not be_nil
		puts $PROGRAM_NAME
		puts StackedConfig::SourceHelper.gem_config_root
	end

end
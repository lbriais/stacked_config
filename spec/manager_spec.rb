require 'spec_helper'

describe StackedConfig::Orchestrator do

  subject {StackedConfig::Orchestrator.new}

  context 'when talking about places where files are' do

    it 'can return the list of relevant places per os' do
      expect(subject.config_file_places.is_a? Hash).to be_truthy
      subject.supported_levels.each do |level|
        expect(subject.config_file_places(level).is_a? Array).to be_truthy
      end
    end



  end

end
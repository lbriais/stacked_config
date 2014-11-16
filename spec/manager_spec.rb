require 'spec_helper'

describe StackedConfig::Orchestrator do

  subject {StackedConfig::Orchestrator.new}

  context 'when talking about places where files are' do

    it 'can return the list of relevant places per os' do
      puts subject.config_file_places
    end



  end

end
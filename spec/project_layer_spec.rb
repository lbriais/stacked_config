require 'spec_helper'

describe StackedConfig::Layers::ProjectLayer do

  let(:test_root) { File.expand_path '../../test/tst_project_layer', __FILE__ }
  let(:search_from_place1) { File.join test_root, 'single', 'level1', 'level2', 'level3' }
  let(:search_from_place2) { File.join test_root, 'multiple', 'level1', 'level2', 'level3' }
  let(:search_from_place3) { File.join test_root, 'multiple', 'level1', 'level2' }
  let(:config_file_name) { 'test_config_file' }

  let(:file1) { File.join test_root, 'single', 'level1', config_file_name}
  let(:file2) { File.join test_root, 'multiple', 'level1', 'level2', 'level3', config_file_name}
  let(:file3) { File.join test_root, 'multiple', 'level1', config_file_name}

  subject { described_class.new test_root, config_file_name }

  it 'should find the find the first config file in the folders hierarchy' do
    expect(subject.send :find_root_file, config_file_name, search_from_place1).to eq file1
    expect(subject.send :find_root_file, config_file_name, search_from_place2).to eq file2
    expect(subject.send :find_root_file, config_file_name, search_from_place3).to eq file3
  end

  it 'should raise an exception if no file is found' do
    expect {subject.send :find_root_file, :unknown_config_file, search_from_place1 }.to raise_error
  end


end
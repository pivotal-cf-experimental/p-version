require 'spec_helper'
require 'p_version/binaries_yaml'
require 'tmpdir'

describe PVersion::BinariesYaml do
  let(:root_path) { Dir.mktmpdir }

  before do
    FileUtils.cp_r(Dir.glob(File.join(assets_path, 'fake-root', '*')), root_path)
    Dir.chdir(root_path)
  end

  let(:binaries_yaml_file_path) { File.join(root_path, 'metadata_parts', 'binaries.yml') }
  let(:binaries_yaml_file_path_bumped) { File.join(root_path, 'bumped', 'binaries.yml') }

  describe '.build' do
    let(:binaries_yaml) { PVersion::BinariesYaml.build(root_path) }
    it 'initializes a BinariesYaml object using a file' do
      expect(binaries_yaml.old_version).to eq('1.2.3.4-alpha32')
    end
  end

  subject(:binaries_yaml) { described_class.new(binaries_yaml_hash, binaries_yaml_file_path) }
  let(:binaries_yaml_hash) do
    {
      'name'                      => 'example-product',
      'product_version'           => '1.2.3.4-alpha32',
      'metadata_version'          => '1.2',
      'provides_product_versions' => [
        {
          'name'    => 'example-product',
          'version' => '1.2.3.4-alpha32'
        }
      ]
    }
  end

  let(:updated_binaries_yaml_hash) do
    {
      'name'                      => 'example-product',
      'product_version'           => '1.2.3.4-alpha33',
      'metadata_version'          => '1.2',
      'provides_product_versions' => [
        {
          'name'    => 'example-product',
          'version' => '1.2.3.4-alpha33'
        }
      ]
    }
  end

  describe '#old_version' do
    it 'returns the string of the product version, before incrementing' do
      expect(binaries_yaml.old_version).to eq('1.2.3.4-alpha32')
    end
  end

  describe '#new_version' do
    it 'returns the string of the product version, after incrementing' do
      expect(binaries_yaml.new_version).to eq('1.2.3.4-alpha33')
    end
  end

  describe '#bump_version_and_save' do
    subject(:binaries_yaml) { PVersion::BinariesYaml.build(root_path) }

    it 'writes out an updated YAML with the bumped version number' do
      binaries_yaml.bump_version_and_save
      expect(YAML.load_file(binaries_yaml_file_path)).to eq(YAML.load_file(binaries_yaml_file_path_bumped))
    end
  end
end

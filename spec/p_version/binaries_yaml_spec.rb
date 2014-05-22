require 'p_version/binaries_yaml'
require 'spec_helper'

describe PVersion::BinariesYaml do

  describe '.build' do
    it 'initializes a BinariesYaml object using a file' do
      Dir.chdir(SPEC_ROOT)
      binaries_yaml = PVersion::BinariesYaml.build(File.join(assets_path, 'metadata_parts', 'binaries.yml'))
      expect(binaries_yaml.old_version).to eq('1.3.0.0')
    end
  end

  subject(:binaries_yaml) { described_class.new(binaries_yaml_hash) }
  let(:binaries_yaml_hash) do
    {
      'name' => 'example-product',
      'product_version' => '1.2.3.4-alpha32',
      'metadata_version' => '1.2',
      'provides_product_versions' => [
        {
          'name' => ' example-product',
          'version' => '1.2.3.4.alpha.32'
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
end
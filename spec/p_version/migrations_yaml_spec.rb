require 'spec_helper'
require 'p_version/migrations_yaml'
require 'tmpdir'

describe PVersion::MigrationsYaml do
  let(:root_path) { Dir.mktmpdir }

  before do
    FileUtils.cp_r(Dir.glob(File.join(assets_path, 'fake-root', '*')), root_path)
    Dir.chdir(root_path)
  end

  let(:migrations_yaml_file_path) { File.join(root_path, 'content_migrations', 'migration.yml') }
  let(:migrations_yaml_file_path_bumped) { File.join(root_path, 'bumped', 'migration.yml') }

  describe '.build' do

    let(:migrations_yaml) { PVersion::MigrationsYaml.build(root_path) }
    it 'initializes a MigrationsYaml object using a file' do
      expect(migrations_yaml.old_version).to eq('1.2.3.4-alpha32')
    end

    it 'uses the correct file as long as it is a .yml file' do
      FileUtils.move(migrations_yaml_file_path, File.join(root_path, 'content_migrations', 'woohoo.yml'))
      expect(migrations_yaml.old_version).to eq('1.2.3.4-alpha32')
    end

    it 'fails if there is more than one .yml file' do
      FileUtils.touch(File.join(root_path, 'content_migrations', 'one_too_many.yml'))
      expect { migrations_yaml }.to raise_error(/which content_migrations YAML file to use/)
    end

    it 'fails if there are no .yml files' do
      FileUtils.rm_r(migrations_yaml_file_path)
      expect { migrations_yaml }.to raise_error(/which content_migrations YAML file to use/)
    end
  end

  subject(:migrations_yaml) { described_class.new(migrations_yaml_hash, migrations_yaml_file_path) }
  let(:migrations_yaml_hash) do
    {
      'product'                   => 'example-product',
      'installation_version'      => '1.1.0.0',
      'to_version'                => '1.2.3.4-alpha32',
      'migrations' => [
        {
          'from_version'    => '1.1.0.0',
          'rules' => [
            {
              'type'     => 'update',
              'selector' => 'product_version',
              'to'       => '1.2.3.4-alpha32'
            }
          ]
        }
      ]
    }
  end

  let(:updated_migrations_yaml_hash) do
    {
      'product'                   => 'example-product',
      'installation_version'      => '1.1.0.0',
      'to_version'                => '1.2.3.4-alpha32',
      'migrations' => [
        {
          'from_version'    => '1.1.0.0',
          'rules' => [
            {
              'type'     => 'update',
              'selector' => 'product_version',
              'to'       => '1.2.3.4-alpha32'
            }
          ]
        }
      ]
    }
  end

  describe '#old_version' do
    it 'returns the string of the product version, before incrementing' do
      expect(migrations_yaml.old_version).to eq('1.2.3.4-alpha32')
    end
  end

  describe '#new_version' do
    it 'returns the string of the product version, after incrementing' do
      expect(migrations_yaml.new_version).to eq('1.2.3.4-alpha33')
    end
  end

  describe '#bump_version_and_save' do
    subject(:migrations_yaml) { PVersion::MigrationsYaml.build(root_path) }

    it 'writes out an updated YAML with the bumped version number' do
      migrations_yaml.bump_version_and_save
      expect(YAML.load_file(migrations_yaml_file_path)).to eq(YAML.load_file(migrations_yaml_file_path_bumped))
    end
  end
end

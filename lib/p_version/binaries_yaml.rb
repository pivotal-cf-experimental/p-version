require 'yaml'

module PVersion
  class BinariesYaml
    def self.build(binaries_yaml_path)
      binaries_yaml = YAML.load_file(binaries_yaml_path)
      new(binaries_yaml, binaries_yaml_path)
    end

    def initialize(binaries_hash, binaries_yaml_path)
      @binaries_hash = binaries_hash
      @binaries_yaml_path = binaries_yaml_path
    end

    def old_version
      binaries_hash.fetch('product_version')
    end

    def new_version
      number = old_version.match(/([0-9]+)$/)[-1]
      next_number = number.to_i + 1
      old_version.gsub(/[0-9]+$/, next_number.to_s)
    end

    def bump_version_and_save
      save(hash_with_bumped_version.to_yaml)
    end

    private

    attr_reader :binaries_hash, :binaries_yaml_path

    def hash_with_bumped_version
      updated_binaries_hash = binaries_hash.dup
      updated_binaries_hash['product_version'] = new_version
      provides_product_version = updated_binaries_hash['provides_product_versions'].find { |product| product['name'] == product_name }
      provides_product_version['version'] = new_version
      updated_binaries_hash
    end

    def save(contents)
      File.open(binaries_yaml_path, 'w') do |f|
        f.write(contents)
      end
    end

    def product_name
      binaries_hash.fetch('name')
    end
  end
end

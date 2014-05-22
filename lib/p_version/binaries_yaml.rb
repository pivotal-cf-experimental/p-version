require 'yaml'

module PVersion
  class BinariesYaml

    def self.build(binaries_yaml_path)
      binaries_yaml = YAML.load_file(binaries_yaml_path)
      self.new(binaries_yaml)
    end

    def initialize(binaries_hash)
      @binaries_hash = binaries_hash
    end

    def old_version
      binaries_hash.fetch('product_version')
    end

    def new_version
      number = old_version.match(/([0-9]+)$/)[-1]
      next_number = number.to_i + 1
      old_version.gsub(/[0-9]+$/,next_number.to_s)
    end

    private

    attr_reader :binaries_hash
  end
end
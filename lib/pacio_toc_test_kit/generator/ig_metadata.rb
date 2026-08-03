require 'pacio_inferno_core/generator/ig_metadata'

module PacioTOCTestKit
  class Generator
    class IGMetadata < PacioInfernoCore::Generator::IGMetadata
      def to_hash
        {
          ig_version:,
          groups: groups.map(&:to_hash)
        }
      end
    end
  end
end

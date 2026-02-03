require 'us_core_test_kit/generator/ig_metadata'

module PacioTOCTestKit
  class Generator
    class IGMetadata < USCoreTestKit::Generator::IGMetadata
      def to_hash
        {
          ig_version:,
          groups: groups.map(&:to_hash)
        }
      end
    end
  end
end

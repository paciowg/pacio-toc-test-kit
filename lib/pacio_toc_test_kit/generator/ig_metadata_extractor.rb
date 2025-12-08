require 'us_core_test_kit/generator/ig_metadata_extractor'
require_relative 'ig_metadata'
require_relative 'group_metadata_extractor'

module PacioTOCTestKit
  class Generator
    class IGMetadataExtractor < USCoreTestKit::Generator::IGMetadataExtractor
      def initialize(ig_resources)
        super
        self.metadata = IGMetadata.new
      end

      def remove_extra_supported_profiles
        # NO extra profiles to be removed.
      end

      def add_metadata_from_resources
        metadata.groups =
          resources_in_capability_statement.flat_map do |resource|
            resource.supportedProfile&.map do |supported_profile|
              GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
            end
          end.compact

        metadata.postprocess_groups(ig_resources)
      end
    end
  end
end

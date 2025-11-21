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
              # There is a bug in TOC#1.0.0-ballot which put html into the supported profile array
              if supported_profile == 'https://hl7.org/fhir/us/pacio-toc/StructureDefinition-TOC-Composition-Header.html'
                supported_profile = 'http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-Composition'
              elsif supported_profile == 'https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-patient.html'
                supported_profile = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'
              end

              GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
            end
          end.compact

        metadata.postprocess_groups(ig_resources)
      end
    end
  end
end

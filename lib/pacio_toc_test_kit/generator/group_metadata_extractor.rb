require 'us_core_test_kit/generator/group_metadata_extractor'

require_relative 'group_metadata'
require_relative 'ig_metadata'
require_relative 'must_support_metadata_extractor'
require_relative 'search_metadata_extractor'
require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class GroupMetadataExtractor < USCoreTestKit::Generator::GroupMetadataExtractor
      def group_metadata
        @group_metadata ||=
          GroupMetadata.new(group_metadata_hash)
      end

      def class_name
        base_name
          .split('-')
          .map(&:capitalize)
          .join
          .gsub('TOC', "TOC#{ig_metadata.reformatted_version}")
          .concat('Sequence')
      end

      def title
        # TODO: Bundle profile is incorrectly named as "Transitions of Care Bundle". 
        # After author fix the name, we could remove the "s?" in the regex
        title = (profile.title || profile.name).gsub(/Transitions?\s*of\s*Care\s*/, '').strip
        title = title.gsub(/US\s*Core\s*/, '').gsub(/\s*Profile/, '').strip

        if Naming.resources_with_multiple_profiles.include?(resource) && !title.start_with?(resource)
          title = "#{resource} #{title.split(resource).map(&:strip).join(' ')}"
        end

        title
      end

      def search_metadata_extractor
        @search_metadata_extractor ||= SearchMetadataExtractor.new(
          resource_capabilities,
          ig_resources,
          profile_elements,
          {
            resource: resource,
            profile_url: profile_url,
            must_supports: must_supports
          }
        )
      end

      def must_support_metadata_extractor
        @must_support_metadata_extractor ||=
          MustSupportMetadataExtractor.new(profile_elements, profile, resource, ig_resources)
      end
      
      def references
        @references ||=
          profile_elements
            .select { |element| element.type&.any? { |t| t.code == 'Reference' } }
            .map do |reference_definition|
              reference_type = reference_definition.type.find { |t| t.code == 'Reference' }
              {
                path: reference_definition.path,
                profiles: reference_type.targetProfile
              }
            end
      end
    end
  end
end

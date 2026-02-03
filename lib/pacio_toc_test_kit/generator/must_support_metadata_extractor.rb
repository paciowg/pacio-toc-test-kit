require 'us_core_test_kit/generator/must_support_metadata_extractor'

module PacioTOCTestKit
  class Generator
    class MustSupportMetadataExtractor < USCoreTestKit::Generator::MustSupportMetadataExtractor
      def is_uscdi_requirement_element?(element)
        false
      end

      def must_support_slices
        type_slices + value_slices + profile_slices
      end
      
      def must_support_profile_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'profile'
        end
      end

      # TOC Bundle profile has "profile" slices
      def profile_slices
        must_support_profile_slice_elements.map do |current_element|
          discriminator = discriminators(sliced_element(current_element)).first
          discriminator_path = discriminator.path
          discriminator_path = '' if discriminator_path == '$this'
          profile_element =
            if discriminator_path.present?
              profile_elements.find { |element| element.id == "#{current_element.id}.#{discriminator_path}" }
            else
              current_element
            end

          profile_url = profile_element.type.first.profile.first

          {
            slice_id: current_element.id,
            slice_name: current_element.sliceName,
            path: current_element.path.gsub("#{resource}.", ''),
            discriminator: {
              type: 'profile',
              path: discriminator.path,
              profile: profile_url
            }
          }
        end
      end

      def handle_special_cases
        # No special cases for TOC
      end
    end
  end
end

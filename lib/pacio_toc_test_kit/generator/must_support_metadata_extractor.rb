require 'us_core_test_kit/generator/must_support_metadata_extractor'

module PacioTOCTestKit
  class Generator
    class MustSupportMetadataExtractor < USCoreTestKit::Generator::MustSupportMetadataExtractor
      def all_must_support_elements
        profile_elements.select(&:mustSupport)
      end

      def type_slices
        must_support_type_slice_elements.map do |current_element|
          discriminator = discriminators(sliced_element(current_element)).first
          type_path = discriminator.path
          type_path = '' if type_path == '$this'
          type_element =
            if type_path.present?
              profile_elements.find { |element| element.id == "#{current_element.id}.#{type_path}" }
            else
              current_element
            end

          type_code = type_element.type.first.code

          {
            slice_id: current_element.id,
            slice_name: current_element.sliceName,
            path: current_element.path.gsub("#{resource}.", ''),
            discriminator: {
              type: 'type',
              code: type_code.upcase_first
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

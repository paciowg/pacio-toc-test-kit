require 'us_core_test_kit/generator/read_test_generator'
require_relative 'naming'
require_relative 'special_cases'

module PacioTOCTestKit
  class Generator
    class ReadTestGenerator < USCoreTestKit::Generator::ReadTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .select { |group| read_interaction(group).present? }
            .each { |group| new(group, base_output_dir).generate }
        end

        def read_interaction(group_metadata)
          group_metadata.interactions.find { |interaction| interaction[:code] == 'read' }
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'read.rb.erb'))
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "#{Naming::SHORT_NAME.downcase}_#{group_metadata.reformatted_version}_#{profile_identifier}_read_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}ReadTest"
      end

      def module_name
        "Pacio#{Naming::SHORT_NAME}#{group_metadata.reformatted_version.upcase}"
      end

      def input_resource_id?
        SpecialCases::PROFILES_NEED_ID_INPUT.include?(profile_identifier)
      end

      def resource_id_input_string
        "#{profile_identifier}_resource_ids"
      end

      def optional_profile?
        SpecialCases::OPTIONAL_RESOURCES.include?(resource_type) || group_metadata.optional_profile?
      end

      def group_title
        group_metadata.title
      end

      def resource_collection_string
        if input_resource_id?
          "all_scratch_resources, resource_ids: #{resource_id_input_string}"
        else
          super
        end
      end      
    end
  end
end

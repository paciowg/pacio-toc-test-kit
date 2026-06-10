require 'pacio_inferno_core/generator/read_test_generator'
require_relative 'naming'
require_relative 'special_cases'

module PacioTOCTestKit
  class Generator
    class ReadTestGenerator < PacioInfernoCore::Generator::ReadTestGenerator
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

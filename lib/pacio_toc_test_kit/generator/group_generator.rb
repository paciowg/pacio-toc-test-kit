require 'pacio_inferno_core/generator/group_generator'

require_relative 'naming'
require_relative 'special_cases'

module PacioTOCTestKit
  class Generator
    class GroupGenerator < PacioInfernoCore::Generator::GroupGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.ordered_groups
            .each { |group| new(group, base_output_dir).generate }
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'group.rb.erb'))
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}Group"
      end

      def module_name
        "PacioTOC#{group_metadata.reformatted_version.upcase}"
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def group_id
        "toc_#{group_metadata.reformatted_version}_#{profile_identifier}"
      end

      def add_special_tests
        case resource_type
        when 'DocumentReference'
          add_custom_test('document_reference_bundle_read_test')
        when 'Bundle'
          add_custom_test('bundle_composition_read_test')
        end
      end

      def add_custom_test(test_name)
        test_id = "toc_#{group_metadata.reformatted_version}_#{test_name}"
        return if group_metadata.tests&.any? { |test| test[:id] == test_id }

        group_metadata.add_test(
          id: test_id,
          file_name: "../../custom_groups/#{group_metadata.version}/#{test_name}.rb"
        )
      end

      def description
        <<~DESCRIPTION
          # Background

          The TOC #{title} sequence verifies that the system under test is
          able to provide correct responses for #{resource_type} queries. These queries
          must contain resources conforming to the #{profile_name} as
          specified in the TOC #{group_metadata.version} Implementation Guide.

          # Testing Methodology
          #{search_description}

          ## Must Support
          Each profile contains elements marked as "must support". This test
          sequence expects to see each of these elements at least once. If at
          least one cannot be found, the test will fail. The test will look
          through the #{resource_type} resources found in the first test for these
          elements.

          ## Profile Validation
          Each resource returned from the first search is expected to conform to
          the [#{profile_name}](#{profile_url}).
          Each element is checked against terminology binding and cardinality requirements.

          Elements with a required binding are validated against their bound
          ValueSet. If the code/system in the element is not part of the ValueSet,
          then the test will fail.

          ## Reference Validation
          At least one instance of each external reference in elements marked as
          "must support" within the resources provided by the system must resolve.
          The test will attempt to read each reference found and will fail if no
          read succeeds.
        DESCRIPTION
      end
    end
  end
end

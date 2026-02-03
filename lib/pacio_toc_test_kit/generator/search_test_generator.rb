require 'us_core_test_kit/generator/search_test_generator'
require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class SearchTestGenerator < USCoreTestKit::Generator::SearchTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .select { |group| group.searches.present? }
            .each do |group|
              group.searches.each { |search| new(group, search, base_output_dir).generate }
            end
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'search.rb.erb'))
      end

      def test_id
        "#{Naming::SHORT_NAME.downcase}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_search_test"
      end

      def module_name
        "Pacio#{Naming::SHORT_NAME}#{group_metadata.reformatted_version.upcase}"
      end

      def search_test_properties_string
        search_properties
          .map { |key, value| "#{' ' * 10}#{key}: #{value}" }
          .join(",\n")
      end

      def reference_search_description
        return '' unless test_reference_variants?

        <<~REFERENCE_SEARCH_DESCRIPTION
          This test verifies that the server supports searching by reference using
          the form `patient=[id]` as well as `patient=Patient/[id]`. The two
          different forms are expected to return the same number of results.
        REFERENCE_SEARCH_DESCRIPTION
      end

      def post_search_description
        return '' unless test_post_search?

        <<~POST_SEARCH_DESCRIPTION
          Additionally, this test will check that GET and POST search methods
          return the same number of results. Search by POST is required by the
          FHIR R4 specification, and these tests interpret search by GET as a
          requirement of PACIO #{Naming::SHORT_NAME} #{group_metadata.version}.
        POST_SEARCH_DESCRIPTION
      end

      def description
        <<~DESCRIPTION.gsub(/\n{3,}/, "\n\n")
          A server #{conformance_expectation} support searching by
          #{search_param_name_string} on the #{resource_type} resource. This test
          will pass if resources are returned and match the search criteria. If
          none are returned, the test is skipped.

          #{reference_search_description}
          #{first_search_description}
          #{post_search_description}

          [PACIO #{Naming::SHORT_NAME} Server CapabilityStatement](#{ig_link}/CapabilityStatement-toc.html)
        DESCRIPTION
      end
    end
  end
end

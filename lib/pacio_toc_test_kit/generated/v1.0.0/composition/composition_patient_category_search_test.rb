require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module PacioTOCTestKit
  module PacioTOCV100
    class CompositionPatientCategorySearchTest < Inferno::Test
      include PacioTOCTestKit::SearchTest

      title 'Server returns valid results for Composition search by patient + category'
      description %(
A server SHALL support searching by
patient + category on the Composition resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

This test verifies that the server supports searching by reference using
the form `patient=[id]` as well as `patient=Patient/[id]`. The two
different forms are expected to return the same number of results.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of PACIO TOC v1.0.0.

[PACIO TOC Server CapabilityStatement](/CapabilityStatement-toc.html)

      )

      id :toc_v100_composition_patient_category_search_test
      optional

      input :patient_ids,
            title: 'Patient IDs',
            description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

      def self.properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          first_search: true,
          fixed_value_search: true,
          resource_type: 'Composition',
          search_param_names: ['patient', 'category'],
          token_search_params: ['category'],
          test_reference_variants: true,
          test_post_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:composition_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end

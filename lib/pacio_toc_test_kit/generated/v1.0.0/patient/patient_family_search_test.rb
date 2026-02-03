require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module PacioTOCTestKit
  module PacioTOCV100
    class PatientFamilySearchTest < Inferno::Test
      include PacioTOCTestKit::SearchTest

      title 'Server returns valid results for Patient search by family'
      description %(
A server SHALL support searching by
family on the Patient resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[PACIO TOC Server CapabilityStatement](/CapabilityStatement-toc.html)

      )

      id :toc_v100_patient_family_search_test
      def self.properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'Patient',
          search_param_names: ['family']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:patient_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end

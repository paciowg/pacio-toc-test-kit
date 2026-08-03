require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module PacioTOCTestKit
  module PacioTOCV100
    class PatientPhoneSearchTest < Inferno::Test
      include PacioTOCTestKit::SearchTest

      title 'Server returns valid results for Patient search by phone'
      description %(
A server SHOULD support searching by
phone on the Patient resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[PACIO TOC Server CapabilityStatement](/CapabilityStatement-toc.html)

      )

      id :toc_v100_patient_phone_search_test
      optional

      def self.properties
        @properties ||= PacioInfernoCore::SearchTestProperties.new(
          resource_type: 'Patient',
          search_param_names: ['phone']
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

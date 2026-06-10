require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module PacioTOCTestKit
  module PacioTOCV100
    class DocumentReferenceIdSearchTest < Inferno::Test
      include PacioTOCTestKit::SearchTest

      title 'Server returns valid results for DocumentReference search by _id'
      description %(
A server SHALL support searching by
_id on the DocumentReference resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[PACIO TOC Server CapabilityStatement](/CapabilityStatement-toc.html)

      )

      id :toc_v100_document_reference__id_search_test
      def self.properties
        @properties ||= PacioInfernoCore::SearchTestProperties.new(
          resource_type: 'DocumentReference',
          search_param_names: ['_id']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end

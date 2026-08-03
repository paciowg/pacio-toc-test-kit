require_relative '../../../must_support_test'

module PacioTOCTestKit
  module PacioTOCV100
    class DocumentReferenceMustSupportTest < Inferno::Test
      include PacioTOCTestKit::MustSupportTest

      title 'All must support elements are provided in the DocumentReference resources returned'

      description %(
        This test will look through the DocumentReference resources
        found previously for the following must support elements:

        * DocumentReference.author
        * DocumentReference.category
        * DocumentReference.content
        * DocumentReference.content.attachment
        * DocumentReference.content.attachment.contentType
        * DocumentReference.content.attachment.creation
        * DocumentReference.content.attachment.data
        * DocumentReference.content.attachment.url
        * DocumentReference.content.format
        * DocumentReference.context
        * DocumentReference.context.encounter
        * DocumentReference.context.period
        * DocumentReference.custodian
        * DocumentReference.date
        * DocumentReference.extension:PointOfContactExtension
        * DocumentReference.identifier
        * DocumentReference.status
        * DocumentReference.subject
        * DocumentReference.type.coding.code
      )

      id :toc_v100_document_reference_must_support_test

      def resource_type
        'DocumentReference'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end

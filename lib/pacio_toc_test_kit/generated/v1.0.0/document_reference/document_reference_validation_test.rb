require 'pacio_inferno_core/validation_test'

module PacioTOCTestKit
  module PacioTOCV100
    class DocumentReferenceValidationTest < Inferno::Test
      include PacioInfernoCore::ValidationTest

      id :toc_v100_document_reference_validation_test

      title <<~DESC
        DocumentReference resources returned during previous tests conform to the Transition of Care Document Reference
      DESC

      description %(
This test verifies resources returned from the first search conform to
the [Transition of Care Document Reference](http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-DocumentReference).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )

      output :dar_code_found, :dar_extension_found

      def resource_type
        'DocumentReference'
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-DocumentReference',
                                '1.0.0')
      end
    end
  end
end

require 'us_core_test_kit/validation_test'

module PacioTOCTestKit
  module PacioTOCV100
    class BundleValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :toc_v100_bundle_validation_test

      title <<~DESC
        Bundle resources returned during previous tests conform to the Transition of Care Bundle
      DESC

      description %(
This test verifies resources returned from the first search conform to
the [Transition of Care Bundle](http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-Bundle).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )

      output :dar_code_found, :dar_extension_found

      def resource_type
        'Bundle'
      end

      def scratch_resources
        scratch[:bundle_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-Bundle',
                                '1.0.0-ballot')
      end
    end
  end
end

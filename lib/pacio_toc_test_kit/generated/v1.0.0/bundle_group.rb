require_relative 'bundle/bundle_read_test'
require_relative 'bundle/bundle_validation_test'
require_relative 'bundle/bundle_must_support_test'

module PacioTOCTestKit
  module PacioTOCV100
    class BundleGroup < Inferno::TestGroup
      title 'Bundle Tests'
      short_description <<~DESC
        'Verify support for the server capabilities required by the Transition of Care Bundle.'
      DESC
      description %(
# Background

The TOC Bundle sequence verifies that the system under test is
able to provide correct responses for Bundle queries. These queries
must contain resources conforming to the Transition of Care Bundle as
specified in the TOC v1.0.0 Implementation Guide.

# Testing Methodology


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the Bundle resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [Transition of Care Bundle](http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-Bundle).
Each element is checked against terminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :toc_v100_bundle
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(
          YAML.load_file(File.join(__dir__, 'bundle', 'metadata.yml'), aliases: true)
        )
      end

      test from: :toc_v100_bundle_read_test
      test from: :toc_v100_bundle_validation_test
      test from: :toc_v100_bundle_must_support_test
    end
  end
end

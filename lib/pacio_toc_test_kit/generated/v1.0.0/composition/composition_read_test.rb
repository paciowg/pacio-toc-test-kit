require_relative '../../../read_test'

module PacioTOCTestKit
  module PacioTOCV100
    class CompositionReadTest < Inferno::Test
      include PacioTOCTestKit::ReadTest

      title 'Server returns correct Composition resource from Composition read interaction'
      description 'A server MAY support the Composition read interaction.'

      id :toc_v100_composition_read_test

      def resource_type
        'Composition'
      end

      def scratch_resources
        scratch[:composition_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Composition'), delayed_reference: true)
      end
    end
  end
end

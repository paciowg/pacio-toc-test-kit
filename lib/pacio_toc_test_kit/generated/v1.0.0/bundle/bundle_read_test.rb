require_relative '../../../read_test'

module PacioTOCTestKit
  module PacioTOCV100
    class BundleReadTest < Inferno::Test
      include PacioTOCTestKit::ReadTest

      title 'Server returns correct Bundle resource from Bundle read interaction'
      description 'A server SHALL support the Bundle read interaction.'

      id :toc_v100_bundle_read_test

      def resource_type
        'Bundle'
      end

      def scratch_resources
        scratch[:bundle_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end

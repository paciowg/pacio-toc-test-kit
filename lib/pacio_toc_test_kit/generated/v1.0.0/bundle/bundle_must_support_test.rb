require_relative '../../../must_support_test'

module PacioTOCTestKit
  module PacioTOCV100
    class BundleMustSupportTest < Inferno::Test
      include PacioTOCTestKit::MustSupportTest

      title 'All must support elements are provided in the Bundle resources returned'

      description %(
        This test will look through the Bundle resources
        found previously for the following must support elements:

        * Bundle.entry:advance-directives
        * Bundle.entry:allergies
        * Bundle.entry:encounter
        * Bundle.entry:encounter-diagnosis
        * Bundle.entry:immunizations
        * Bundle.entry:location
        * Bundle.entry:medical-devices
        * Bundle.entry:medications
        * Bundle.entry:organization
        * Bundle.entry:patient
        * Bundle.entry:plan-of-care
        * Bundle.entry:practitioner
        * Bundle.entry:practitioner-role
        * Bundle.entry:problems
        * Bundle.entry:procedures
        * Bundle.entry:simple-observation
        * Bundle.entry:toc-composition
        * Bundle.entry:vital-signs
        * Bundle.identifier
      )

      id :toc_v100_bundle_must_support_test

      def resource_type
        'Bundle'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:bundle_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end

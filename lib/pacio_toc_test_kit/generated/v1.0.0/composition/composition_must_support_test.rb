require 'us_core_test_kit/must_support_test'

module PacioTOCTestKit
  module PacioSMPV100
    class CompositionMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Composition resources returned'

      description %(
        This test will look through the Composition resources
        found previously for the following must support elements:

        * Composition.author
        * Composition.category.coding.code
        * Composition.custodian
        * Composition.date
        * Composition.identifier
        * Composition.language
        * Composition.section.text
        * Composition.section:advance_directives
        * Composition.section:advance_directives.text
        * Composition.section:advance_directives.title
        * Composition.section:allergies
        * Composition.section:allergies.text
        * Composition.section:allergies.title
        * Composition.section:behavioral_health
        * Composition.section:behavioral_health.text
        * Composition.section:behavioral_health.title
        * Composition.section:functional_status
        * Composition.section:functional_status.text
        * Composition.section:functional_status.title
        * Composition.section:immunizations
        * Composition.section:immunizations.text
        * Composition.section:immunizations.title
        * Composition.section:instructions
        * Composition.section:instructions.text
        * Composition.section:instructions.title
        * Composition.section:medication_equipment
        * Composition.section:medication_equipment.text
        * Composition.section:medication_equipment.title
        * Composition.section:medications
        * Composition.section:medications.text
        * Composition.section:medications.title
        * Composition.section:plan_of_care
        * Composition.section:plan_of_care.text
        * Composition.section:plan_of_care.title
        * Composition.section:problems
        * Composition.section:problems.text
        * Composition.section:problems.title
        * Composition.section:procedures
        * Composition.section:procedures.text
        * Composition.section:procedures.title
        * Composition.section:reason_for_referral
        * Composition.section:reason_for_referral.text
        * Composition.section:reason_for_referral.title
        * Composition.section:reason_for_visit
        * Composition.section:reason_for_visit.text
        * Composition.section:reason_for_visit.title
        * Composition.section:results
        * Composition.section:results.text
        * Composition.section:results.title
        * Composition.section:social_history
        * Composition.section:social_history.text
        * Composition.section:social_history.title
        * Composition.section:vital_signs
        * Composition.section:vital_signs.text
        * Composition.section:vital_signs.title
        * Composition.subject
        * Composition.title
        * Composition.type
      )

      id :toc_v100_composition_must_support_test

      def resource_type
        'Composition'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:composition_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end

module PacioTOCTestKit
  class Generator
    module SpecialCases
      OPTIONAL_RESOURCES = [
        'Bundle',
        'Medication',
        'MedicationAdministration',
        'MedicationRequest'
      ].freeze

      # Identifier for profiles that need input ID
      PROFILES_NEED_ID_INPUT = [
        'bundle',
        'bundle_transaction'
      ]
    end
  end
end
module PacioTOCTestKit
  class Generator
    module SpecialCases
      # The generator will create optional test groups for these resources. If a
      # client or server supports them, the client or server must pass all of the
      # associated tests. This list is not IG version specific.
      # Generator must populate this array or set to empty.      
      OPTIONAL_RESOURCES = [
      ].freeze

      # Identifier for profiles that need input ID. Inferno willGenerator will put read test as
      # the first test for these resources.
      PROFILES_NEED_ID_INPUT = [
        'bundle'
      ]
    end
  end
end
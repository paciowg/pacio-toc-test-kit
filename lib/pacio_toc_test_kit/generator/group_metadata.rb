require 'us_core_test_kit/generator/group_metadata'

module PacioTOCTestKit
  class Generator
    class GroupMetadata < USCoreTestKit::Generator::GroupMetadata
      def non_uscdi_resource?
        false
      end
    end
  end
end

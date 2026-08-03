require 'pacio_inferno_core/generator/group_metadata'

module PacioTOCTestKit
  class Generator
    class GroupMetadata < PacioInfernoCore::Generator::GroupMetadata
      def non_uscdi_resource?
        false
      end
    end
  end
end

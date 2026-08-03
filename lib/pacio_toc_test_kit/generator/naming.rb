module PacioTOCTestKit
  class Generator
    module Naming
      # From US Core
      PATIENT = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'

      IG_LINKS = {
        'v1.0.0' => 'https://hl7.org/fhir/us/pacio-toc/STU1'
      }.freeze

      class << self
        def resources_with_multiple_profiles
          []
        end

        def prefix
          'toc'
        end

        def implementation_guide_id
          "hl7.fhir.us.pacio-#{prefix}"
        end

        def module_name
          "Pacio#{prefix.upcase}"
        end

        def long_name
          "PACIO #{prefix.upcase}"
        end

        def resource_has_multiple_profiles?(resource)
          resources_with_multiple_profiles.include? resource
        end

        def snake_case_for_profile(group_metadata)
          resource = group_metadata.resource
          return resource.underscore unless resource_has_multiple_profiles?(resource)

          group_metadata.name
            .delete_prefix("#{prefix}_")
            .underscore
        end

        def upper_camel_case_for_profile(group_metadata)
          snake_case_for_profile(group_metadata).camelize
        end

        def ig_link(version)
          IG_LINKS[version]
        end
      end
    end
  end
end

require 'pacio_inferno_core/generator/ig_metadata_extractor'
require_relative 'ig_metadata'
require_relative 'group_metadata_extractor'

module PacioTOCTestKit
  class Generator
    class IGMetadataExtractor < PacioInfernoCore::Generator::IGMetadataExtractor
      def initialize(ig_resources)
        super
        add_document_reference_resource
        self.metadata = IGMetadata.new
      end

      # PACIO TOC 1.0 CapabilityStatement does not include DocumentReference profile. 
      def add_document_reference_resource
        return unless ig_resources.ig.version == '1.0.0'

        resources_in_capability_statement << FHIR::CapabilityStatement::Rest::Resource.new(
          {
            type: 'DocumentReference',
            extension: [
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "SHALL"
                  },
                  {
                    url: "required",
                    valueString: "patient"
                  },
                  {
                    url: "required",
                    valueString: "category"
                  }
                ],
                url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
              },
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "SHALL"
                  },
                  {
                    url: "required",
                    valueString: "patient"
                  },
                  {
                    url: "required",
                    valueString: "category"
                  },
                  {
                    url: "required",
                    valueString: "date"
                  }
                ],
                url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
              },
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "SHALL"
                  },
                  {
                    url: "required",
                    valueString: "patient"
                  },
                  {
                    url: "required",
                    valueString: "type"
                  }
                ],
                url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
              }
            ],
            supportedProfile: [
              'http://hl7.org/fhir/us/pacio-toc/StructureDefinition/TOC-DocumentReference'
            ],

            interaction: [
              {
                extension: [
                  {
                    url: 'http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation',
                    valueCode: 'SHALL'
                  }
                ],
                code: 'search-type'
              },
              {
                extension: [
                  {
                    url: 'http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation',
                    valueCode: 'SHALL'
                  }
                ],
                code: 'read'
              }
            ],
            searchParam: [
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "SHALL"
                  }
                ],
                name: "_id",
                definition: "http://hl7.org/fhir/us/core/SearchParameter/us-core-documentreference-id",
                type: "token"
              },
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "MAY"
                  }
                ],
                name: "category",
                definition: "http://hl7.org/fhir/us/core/SearchParameter/us-core-documentreference-category",
                type: "token"
              },
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "MAY"
                  }
                ],
                name: "date",
                definition: "http://hl7.org/fhir/us/core/SearchParameter/us-core-documentreference-date",
                type: "date"
              },
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "SHALL"
                  }
                ],
                name: "patient",
                definition: "http://hl7.org/fhir/us/core/SearchParameter/us-core-documentreference-patient",
                type: "reference"
              },
              {
                extension: [
                  {
                    url: "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                    valueCode: "MAY"
                  }
                ],
                name: "type",
                definition: "http://hl7.org/fhir/us/core/SearchParameter/us-core-documentreference-type",
                type: "token"
              }
            ]
          }
        )
      end      

      def remove_extra_supported_profiles
        # NO extra profiles to be removed.
      end

      def add_metadata_from_resources
        metadata.groups =
          resources_in_capability_statement.flat_map do |resource|
            resource.supportedProfile&.map do |supported_profile|
              GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
            end
          end.compact

        metadata.postprocess_groups(ig_resources)
      end
    end
  end
end

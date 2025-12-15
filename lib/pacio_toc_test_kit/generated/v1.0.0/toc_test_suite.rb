require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v1.0.0/capability_statement_group'
require_relative 'patient_group'
require_relative 'bundle_group'
require_relative 'composition_group'

module PacioTOCTestKit
  module PacioTOCV100
    class PacioTOCestSuite < Inferno::TestSuite
      title 'PACIO TOC Server v1.0.0'
      description %(
        The PACIO TOC Server Test Kit tests server systems for their conformance to the [PACIO TOC
        Implementation Guide](https://hl7.org/fhir/us/pacio-toc/2025May/).
      )

      GENERAL_MESSAGE_FILTERS = [].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
          Generator::GroupMetadata.new(raw_metadata)
        end
      end

      id :toc_v100

      fhir_resource_validator do
        igs 'hl7.fhir.us.pacio-toc#1.0.0', 'hl7.fhir.us.core#6.1.0'
        message_filters = VALIDATION_MESSAGE_FILTERS

        exclude_message do |message|
          message_filters.any? { |filter| filter.match? message.message }
        end
      end

      input :url,
            title: 'FHIR Endpoint',
            description: 'URL of the FHIR endpoint'
      input :smart_auth_info,
            title: 'OAuth Credentials',
            type: :auth_info,
            optional: true

      fhir_client do
        url :url
        auth_info :smart_auth_info
      end

      group from: :toc_v100_capability_statement

      group from: :toc_v100_patient
      group from: :toc_v100_bundle
      group from: :toc_v100_composition

      links [
        {
          type: 'report_issue',
          label: 'Report Issue',
          url: 'https://github.com/paciowg/pacio-toc-test-kit/issues/'
        },
        {
          type: 'source_code',
          label: 'Open Source',
          url: 'https://github.com/paciowg/pacio-toc-test-kit/'
        },
        {
          type: 'download',
          label: 'Download',
          url: 'https://github.com/paciowg/pacio-toc-test-kit/releases/'
        }
      ]
    end
  end
end

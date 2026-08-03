# frozen_string_literal: true

require 'uri'

module PacioTOCTestKit
  module PacioTOCV100
    class DocumentReferenceBundleReadTest < Inferno::Test
      ARTIFACT_HEADERS = {
        'Accept' => 'application/fhir+json, application/json+fhir'
      }.freeze

      title 'DocumentReference content attachment URLs resolve to a FHIR Bundle'
      description %(
        This test retrieves artifacts referenced by
        `DocumentReference.content.attachment.url`, saves any document FHIR
        Bundle artifacts with at least one Composition entry and at least one
        Patient entry to scratch, and verifies that at least one artifact meets
        these criteria.
      )

      id :toc_v100_document_reference_bundle_read_test

      def document_reference_resources
        scratch.dig(:document_reference_resources, :all) || []
      end

      def bundle_resources
        scratch[:bundle_resources] ||= {}
        scratch[:bundle_resources][:all] ||= []
      end

      def attachment_urls
        document_reference_resources.flat_map do |document_reference|
          document_reference.content&.filter_map { |content| content.attachment&.url.presence } || []
        end.uniq
      end

      def absolute_artifact_url(attachment_url)
        return attachment_url if attachment_url.match?(%r{\Ahttps?://})

        URI.join("#{fhir_base_url.chomp('/')}/", attachment_url).to_s
      rescue URI::InvalidURIError
        nil
      end

      def fhir_base_url
        fhir_client.instance_variable_get(:@base_service_url)
      end

      def same_fhir_server_url?(artifact_url)
        artifact_uri = URI.parse(artifact_url)
        base_uri = URI.parse(fhir_base_url)
        base_path = base_uri.path.chomp('/')

        artifact_uri.scheme == base_uri.scheme &&
          artifact_uri.host == base_uri.host &&
          artifact_uri.port == base_uri.port &&
          artifact_uri.path.start_with?("#{base_path}/")
      rescue URI::InvalidURIError
        false
      end

      def get_artifact(attachment_url)
        artifact_url = absolute_artifact_url(attachment_url)

        assert artifact_url.present?,
               "DocumentReference.content.attachment.url `#{attachment_url}` is not a valid URL."

        if same_fhir_server_url?(artifact_url)
          store_request_and_refresh_token(fhir_client, nil, []) do
            fhir_client.raw_read_url(artifact_url)
          end
        else
          get(artifact_url, headers: ARTIFACT_HEADERS)
        end
      end

      def fhir_resource_from_request(request)
        request.resource
      rescue StandardError
        nil
      end

      def toc_bundle?(bundle)
        document_bundle?(bundle) &&
          bundle_contains_resource_type?(bundle, FHIR::Composition) &&
          bundle_contains_resource_type?(bundle, FHIR::Patient)
      end

      def document_bundle?(resource)
        resource.is_a?(FHIR::Bundle) && resource.type == 'document'
      end

      def bundle_contains_resource_type?(bundle, resource_class)
        bundle.entry&.any? { |entry| entry.resource.is_a?(resource_class) }
      end

      def save_bundle_resources(bundles)
        bundle_resources.concat(bundles)
        bundle_resources.uniq! { |bundle| [bundle.resourceType, bundle.id, bundle.to_hash] }
      end

      run do
        skip_if document_reference_resources.blank?,
                'No DocumentReference resources were found. Please run the DocumentReference search tests first.'

        urls = attachment_urls
        skip_if urls.blank?,
                'No DocumentReference.content.attachment.url values were found in the DocumentReference resources.'

        bundles = urls.filter_map do |url|
          artifact_request = get_artifact(url)

          assert_response_status(200, request: artifact_request)

          artifact = fhir_resource_from_request(artifact_request)
          artifact if toc_bundle?(artifact)
        end

        save_bundle_resources(bundles)

        assert bundles.present?,
               'No artifacts referenced by DocumentReference.content.attachment.url were document FHIR Bundle ' \
               'resources ' \
               'with at least one Composition entry and at least one Patient entry.'
      end
    end
  end
end

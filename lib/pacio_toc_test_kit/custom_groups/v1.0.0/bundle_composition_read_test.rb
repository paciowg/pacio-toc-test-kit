# frozen_string_literal: true

module PacioTOCTestKit
  module PacioTOCV100
    class BundleCompositionReadTest < Inferno::Test
      TOC_COMPOSITION_CATEGORY_CODE = '18761-7'

      title 'Bundle contains a TOC Composition resource'
      description %(
        This test looks through previously retrieved Bundle resources, saves any
        contained Composition resources with `category` code `18761-7` to
        scratch, and verifies that at least one matching Composition is present.
      )

      id :toc_v100_bundle_composition_read_test

      def bundle_resources
        scratch.dig(:bundle_resources, :all) || []
      end

      def composition_resources
        scratch[:composition_resources] ||= {}
        scratch[:composition_resources][:all] ||= []
      end

      def bundle_entry_resources
        bundle_resources.flat_map do |bundle|
          bundle.entry&.filter_map(&:resource) || []
        end
      end

      def toc_composition?(resource)
        resource.is_a?(FHIR::Composition) &&
          resource.category&.any? do |category|
            category.coding&.any? { |coding| coding.code == TOC_COMPOSITION_CATEGORY_CODE }
          end
      end

      def toc_compositions
        bundle_entry_resources.select { |resource| toc_composition?(resource) }
      end

      def save_compositions(compositions)
        composition_resources.concat(compositions)
        composition_resources.uniq! { |composition| [composition.resourceType, composition.id, composition.to_hash] }
      end

      run do
        skip_if bundle_resources.blank?,
                'No Bundle resources were found. Please run the Bundle read test first.'

        compositions = toc_compositions
        save_compositions(compositions)

        assert compositions.present?,
               'No Composition resources with category code `18761-7` were found in Bundle.entry.resource.'
      end
    end
  end
end

require 'us_core_test_kit/must_support_test'

module PacioTOCTestKit
  module MustSupportTest
    include USCoreTestKit::MustSupportTest
    extend USCoreTestKit::MustSupportTest

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      missing_elements = missing_must_support_elements(resources, nil, metadata:)

      profile_slice_found = find_profile_slices(resources)

      missing_elements.delete_if { |element| profile_slice_found.any? { |slice| slice[:slice_id] == element } }

      skip { assert missing_elements.empty?, missing_must_support_elements_message(missing_elements, resources) }
    end

    def must_support_profile_slices
      metadata.must_supports[:slices].select { |slice| slice[:discriminator][:type] == 'profile' }
    end

    def find_profile_slices(resources)
      must_support_profile_slices.select do |slice|
        resources.any? do |resource|
          find_profile_slice(resource, slice[:path], slice[:discriminator]).present?
        end
      end
    end

    def find_profile_slice(resource, path, discriminator)
      target_path = "#{path}.#{discriminator[:path]}"
      target_profile = discriminator[:profile]

      find_a_value_at(resource, target_path) do |target_resource|
        resource_is_valid_with_target_profile?(target_resource, target_profile)
      end
    end

    def resource_is_valid_with_target_profile?(resource, target_profile)
      return true if target_profile.blank?

      resource_is_valid?(resource:, profile_url: target_profile, add_messages_to_runnable: false)
    end
  end
end

# frozen_string_literal: true

require 'us_core_test_kit/read_test'

module PacioTOCTestKit
  module ReadTest
    include USCoreTestKit::ReadTest
    extend USCoreTestKit::ReadTest

    def perform_read_test(resources, reply_handler = nil, delayed_reference: false, resource_ids: nil)
      if resources.blank? && resource_ids.present?
        resource_ids.split(',').each do |id|
          read_with_id(id)
        end
      else
        super(resources, reply_handler, delayed_reference: delayed_reference)
      end
    end

    def read_with_id(id)
      fhir_read resource_type, id

      assert_response_status(200)
      assert_resource_type(resource_type)
      assert resource.id.present? && resource.id == id, bad_resource_id_message(id)

      all_scratch_resources << resource
    end
  end
end

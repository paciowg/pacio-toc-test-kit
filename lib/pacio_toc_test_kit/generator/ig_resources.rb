require 'us_core_test_kit/generator/ig_resources'
require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class IGResources < USCoreTestKit::Generator::IGResources
      def search_param_by_resource_and_name(resource, name)
        normalized_name = name.to_s.delete_prefix('_')
        resource_lower = resource.downcase
        
        id_match = resources_by_type['SearchParameter'].find do |param|
          param.id == "#{Naming::SHORT_NAME.downcase}-#{resource_lower}-#{normalized_name}" ||
            param.id == "us-core-#{resource_lower}-#{normalized_name}"
        end

        id_match || resources_by_type['SearchParameter'].find { |param| param.name == name }
      end
    end
  end
end

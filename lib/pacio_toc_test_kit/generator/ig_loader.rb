require 'pacio_inferno_core/generator/ig_loader'
require_relative 'ig_resources'

module PacioTOCTestKit
  class Generator
    class IGLoader < PacioInfernoCore::Generator::IGLoader
      def ig_resources
        @ig_resources ||= IGResources.new
      end
    end
  end
end

require 'pacio_inferno_core/generator/suite_generator'

require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class SuiteGenerator < PacioInfernoCore::Generator::SuiteGenerator
      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def title
        "#{Naming.long_name} Server #{ig_metadata.ig_version}"
      end

      def ig_identifier
        version = ig_metadata.ig_version[1..] # Remove leading 'v'
        "#{Naming.implementation_guide_id}##{version}"
      end
    end
  end
end

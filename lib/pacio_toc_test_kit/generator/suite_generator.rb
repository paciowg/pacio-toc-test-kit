require 'us_core_test_kit/generator/suite_generator'

require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class SuiteGenerator < USCoreTestKit::Generator::SuiteGenerator
      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def base_output_file_name
        'toc_test_suite.rb'
      end

      def class_name
        'PacioTOCestSuite'
      end

      def module_name
        "PacioTOC#{ig_metadata.reformatted_version.upcase}"
      end

      def suite_id
        "toc_#{ig_metadata.reformatted_version}"
      end

      def title
        "PACIO TOC Server #{ig_metadata.ig_version}"
      end

      def ig_identifier
        version = ig_metadata.ig_version[1..] # Remove leading 'v'
        "hl7.fhir.us.pacio-toc##{version}"
      end

      def ig_link
        Naming.ig_link(ig_metadata.ig_version)
      end

      def capability_statement_group_id
        "toc_#{ig_metadata.reformatted_version}_capability_statement"
      end
    end
  end
end

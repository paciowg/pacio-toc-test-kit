# frozen_string_literal: true

require 'us_core_test_kit/generator/must_support_test_generator'
require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class MustSupportTestGenerator < USCoreTestKit::Generator::MustSupportTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
                     .each { |group| new(group, base_output_dir).generate }
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'must_support.rb.erb'))
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "toc_#{group_metadata.reformatted_version}_#{profile_identifier}_must_support_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}MustSupportTest"
      end

      def module_name
        "PacioTOC#{group_metadata.reformatted_version.upcase}"
      end
    end
  end
end

# frozen_string_literal: true

require 'pacio_inferno_core/generator/must_support_test_generator'
require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class MustSupportTestGenerator < PacioInfernoCore::Generator::MustSupportTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
                     .each { |group| new(group, base_output_dir).generate }
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'must_support.rb.erb'))
      end
    end
  end
end

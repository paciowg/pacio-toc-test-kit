require 'pacio_inferno_core/generator/validation_test_generator'
require_relative 'naming'

module PacioTOCTestKit
  class Generator
    class ValidationTestGenerator < PacioInfernoCore::Generator::ValidationTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .each { |group| new(group, base_output_dir: base_output_dir).generate }
        end
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'validation.rb.erb'))
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.write(output_file_name, output)

        test_metadata = {
          id: test_id,
          file_name: base_output_file_name
        }

        group_metadata.add_test(**test_metadata)
      end
    end
  end
end

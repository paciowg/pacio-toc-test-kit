require 'us_core_test_kit/generator/search_definition_metadata_extractor'

module PacioTOCTestKit
  class Generator
    class SearchDefinitionMetadataExtractor < USCoreTestKit::Generator::SearchDefinitionMetadataExtractor
      def full_paths
        @full_paths ||=
          begin
            # TOC#1.0.0-ballot uses general search parameters defined in FHIR base spec. 
            # This line is to locate the path related to the resource type.
            path = param.expression.match(/\b#{Regexp.escape(resource)}\.[^|]+/)&.to_s.strip
            path = path.gsub(/.where\(resolve\((.*)/, '').gsub(/url = '/, 'url=\'')
            path = path[1..-2] if path.start_with?('(') && path.end_with?(')')
            path.scan(/[. ]as[( ]([^)]*)[)]?/).flatten.map do |as_type|
              path.gsub!(/[. ]as[( ](#{as_type}[^)]*)[)]?/, as_type.upcase_first) if as_type.present?
            end

            path.gsub!('Resource.', "#{resource}.") if path.start_with?('Resource.')

            full_paths = path.split('|')

            full_paths
          end
      end
    end
  end
end
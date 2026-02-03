module PacioTOCTestKit
  class InstantiateTest < Inferno::Test
    id :toc_instantiate
    title 'Server instantiates PACIO TOC Server'
    description %(
        This test inspects the CapabilityStatement returned by the server to
        verify that the server instantiates http://hl7.org/fhir/us/pacio-toc/CapabilityStatement/toc
      )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      include_us_core = capability_statement.instantiates&.any? do |url|
        url.split('|').first == 'http://hl7.org/fhir/us/pacio-toc/CapabilityStatement/toc'
      end

      assert include_us_core,
             "Server CapabilityStatement.instantiates does not include 'http://hl7.org/fhir/us/pacio-toc/CapabilityStatement/toc'"
    end
  end
end

# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe PacioTOCTestKit::PacioTOCV100::DocumentReferenceGroup do
  let(:suite_id) { 'toc_v100' }
  let(:group) { suite.groups.find { |g| g.id.include?(described_class.id) } }
  let(:url) { 'http://example.com/fhir' }
  let(:bundle_id) { 'bundle-1' }
  let(:bundle_url) { "#{url}/Bundle/#{bundle_id}" }
  let(:document_reference) do
    FHIR::DocumentReference.new(
      id: 'doc-ref-1',
      status: 'current',
      content: [
        {
          attachment: {
            url: bundle_url
          }
        }
      ]
    )
  end
  let(:bundle) do
    FHIR::Bundle.new(
      id: bundle_id,
      meta: {
        profile: [
          PacioTOCTestKit::PacioTOCV100::DocumentReferenceBundleReadTest::TOC_BUNDLE_PROFILE_URL
        ]
      }
    )
  end

  describe 'DocumentReference bundle read test' do
    let(:test) do
      group.tests.find do |group_test|
        group_test.id.include?(PacioTOCTestKit::PacioTOCV100::DocumentReferenceBundleReadTest.id)
      end
    end
    let(:test_scratch) do
      {
        document_reference_resources: {
          all: [document_reference]
        }
      }
    end

    before do
      allow_any_instance_of(test)
        .to receive(:scratch).and_return(test_scratch)
    end

    it 'passes when a DocumentReference attachment URL resolves to a TOC Bundle and saves it to scratch' do
      stub_request(:get, bundle_url)
        .to_return(status: 200, body: bundle.to_json)

      allow_any_instance_of(test)
        .to receive(:resource_is_valid?).and_return(true)

      result = run(test, url: url)

      expect(result.result).to eq('pass')
      expect(test_scratch.dig(:bundle_resources, :all)).to contain_exactly(
        an_object_having_attributes(resourceType: 'Bundle', id: bundle_id)
      )
    end

    it 'fails when no referenced artifact is a TOC Bundle' do
      stub_request(:get, bundle_url)
        .to_return(status: 200, body: bundle.to_json)

      allow_any_instance_of(test)
        .to receive(:resource_is_valid?).and_return(false)

      result = run(test, url: url)

      expect(result.result).to eq('fail')
      expect(result.result_message).to include('conform to the TOC Bundle profile')
      expect(test_scratch.dig(:bundle_resources, :all)).to contain_exactly(
        an_object_having_attributes(resourceType: 'Bundle', id: bundle_id)
      )
    end
  end
end

# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe PacioTOCTestKit::PacioTOCV100::BundleGroup do
  let(:suite_id) { 'toc_v100' }
  let(:group) { suite.groups.find { |g| g.id.include?(described_class.id) } }
  let(:url) { 'http://example.com/fhir' }
  let(:bundle_id) { 'bundle-1' }
  let(:bundle) do
    FHIR::Bundle.new(
      id: bundle_id
    )
  end

  describe 'read test' do
    let(:test) { group.tests.find { |t| t.id.include?('read') } }
    let(:test_scratch) { {} }

    it 'passes search with Bundle returned' do
      stub_request(:get, "#{url}/Bundle/#{bundle_id}")
        .to_return(status: 200, body: bundle.to_json)

      allow_any_instance_of(test)
        .to receive(:scratch).and_return(test_scratch)        
      
      result = run(test, url: url, bundle_resource_ids: bundle_id)
      scratch_resources = test_scratch[:bundle_resources]

      expect(result.result).to eq('pass'), result.result_message
      expect(scratch_resources).not_to be_empty
    end
  end
end

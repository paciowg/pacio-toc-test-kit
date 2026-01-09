# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe PacioTOCTestKit::PacioTOCV100::BundleGroup do
  let(:suite_id) { 'toc_v100' }
  let(:group) { suite.groups.find { |g| g.id.include?(described_class.id) } }
  let(:url) { 'http://example.com/fhir' }
  let(:bundle_id) { 'bundle-1' }
  let(:bundle) do
    FHIR::Bundle.new(
      id: bundle_id,
      identifier: {
        value: 'identifier'
      },
      entry: [
        {
          resource: {
            id: 'patient-1'
          }
        },
        {
          resource: {
            id: 'toc-composition-1'
          }
        }
      ]
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

      expect(result.result).to eq('pass')
      expect(scratch_resources).to_not be_empty
    end
  end

  describe 'must support test' do
    let(:test) { group.tests.find { |t| t.id.include?('must_support') } }

    it 'passes if the Bundle have must support entries' do
      allow_any_instance_of(test)
        .to receive(:scratch).and_return(
          {
            bundle_resources: {
              all: [
                bundle
              ]
            }
          }
        )

      allow_any_instance_of(test)
        .to receive(:resource_is_valid_with_target_profile?).and_return(true)

      result = run(test, url: url)

      expect(result.result).to eq('pass')
    end

    it 'fails if the Bundle does not have must support entries' do
      allow_any_instance_of(test)
        .to receive(:scratch).and_return(
          {
            bundle_resources: {
              all: [
                bundle
              ]
            }
          }
        )

      allow_any_instance_of(test)
        .to receive(:resource_is_valid_with_target_profile?).and_return(false)

      result = run(test, url: url)

      expect(result.result).to eq('skip')
      expect(result.result_message).to_not include('Bundle.identifier')
      expect(result.result_message).to include('Bundle.entry:patient')
      expect(result.result_message).to include('Bundle.entry:toc-composition')
    end
  end
end

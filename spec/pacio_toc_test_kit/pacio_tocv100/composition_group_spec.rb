# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe PacioTOCTestKit::PacioTOCV100::CompositionGroup do
  let(:suite_id) { 'toc_v100' }
  let(:group) { suite.groups.find { |g| g.id.include?(described_class.id) } }
  let(:url) { 'http://example.com/fhir' }
  let(:composition_id) { 'toc-composition-1' }
  let(:composition) do
    FHIR::Composition.new(id: composition_id)
  end

  describe 'read test' do
    let(:test) { group.tests.find { |t| t.id.include?(PacioTOCTestKit::PacioTOCV100::CompositionReadTest.id) } }
    let(:test_scratch) do
      {
        composition_resources: {
          all: [composition]
        }
      }
    end

    before do
      allow_any_instance_of(test)
        .to receive(:scratch).and_return(test_scratch)
    end

    it 'is optional because Composition resources are provided in Bundle entries' do
      expect(test).to be_optional
    end

    it 'reads Composition resources saved from Bundle entries' do
      stub_request(:get, "#{url}/Composition/#{composition_id}")
        .to_return(status: 200, body: composition.to_json)

      result = run(test, url: url)

      expect(result.result).to eq('pass')
    end
  end
end

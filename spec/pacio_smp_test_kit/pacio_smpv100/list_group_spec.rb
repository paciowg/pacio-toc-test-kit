# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe PacioTOCTestKit::PacioTOCV100::ListGroup do
  let(:suite_id) { 'toc_v100' }
  let(:group) { suite.groups.find { |g| g.id.include?(described_class.id) } }
  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { 'patient-1' }
  let(:list_coding) do
    FHIR::Coding.new(
      system: 'http://loinc.org',
      code: '104203-5'
    )
  end
  let(:list) do
    FHIR::List.new(
      id: 'list-1',
      code: {
        coding: [list_coding]
      },
      subject: {
        reference: "Patient/#{patient_id}"
      }
    )
  end
  let(:bundle) do
    FHIR::Bundle.new(entry: [{ resource: list }])
  end

  describe 'patient search test' do
    let(:test) { group.tests.find { |t| t.id.include?('patient_search') } }

    it 'passes search with patient' do
      stub_request(:get, "#{url}/List?patient=#{patient_id}")
        .to_return(status: 200, body: bundle.to_json)
      stub_request(:get, "#{url}/List?patient=Patient/#{patient_id}")
        .to_return(status: 200, body: bundle.to_json)
      stub_request(:post, "#{url}/List/_search")
        .with(
          body: { patient: patient_id }
        )
        .to_return(status: 200, body: bundle.to_json)

      result = run(test, url: url, patient_ids: patient_id)

      expect(result.result).to eq('pass'), result.result_message
    end
  end

  describe 'code search test' do
    let(:test) { group.tests.find { |t| t.id.include?('code_search') } }

    before do
      allow_any_instance_of(test)
        .to receive(:scratch_resources).and_return(
          {
            all: [list],
            patient_id => [list]
          }
        )
    end

    it 'passes if a List with code was received' do
      stub_request(:get, "#{url}/List?code=#{list_coding.code}")
        .to_return(status: 200, body: bundle.to_json)
      stub_request(:get, "#{url}/List?code=#{list_coding.system}%7C#{list_coding.code}")
        .to_return(status: 200, body: bundle.to_json)

      result = run(test, url: url)

      expect(result.result).to eq('pass'), result.result_message
    end
  end
end
